# This essentially "bootstraps" the library from a Ruby script
script_directory = File.dirname(__FILE__)
require File.join(script_directory,"Nx.jar")
java_import "com.nuix.nx.NuixConnection"
java_import "com.nuix.nx.LookAndFeelHelper"
java_import "com.nuix.nx.dialogs.ChoiceDialog"
java_import "com.nuix.nx.dialogs.TabbedCustomDialog"
java_import "com.nuix.nx.dialogs.CommonDialogs"
java_import "com.nuix.nx.dialogs.ProgressDialog"
java_import "com.nuix.nx.dialogs.ProcessingStatusDialog"
java_import "com.nuix.nx.digest.DigestHelper"
java_import "com.nuix.nx.controls.models.Choice"

LookAndFeelHelper.setWindowsIfMetal
NuixConnection.setUtilities($utilities)
NuixConnection.setCurrentNuixVersion(NUIX_VERSION)

require File.join(script_directory,"SuperUtilities.jar")
java_import com.nuix.superutilities.SuperUtilities
$su = SuperUtilities.init($utilities,NUIX_VERSION)
java_import com.nuix.superutilities.annotations.AnnotationRepository
java_import com.nuix.superutilities.annotations.AnnotationMatchingMethod

date = org.joda.time.DateTime.now.toString("YYYYMMDD")

dialog = TabbedCustomDialog.new("Annotation Export/Import")

general_tab = dialog.addTab("general_tab","General Settings")
general_tab.appendRadioButton("export_annotations","Export Annotations","operation_type_group",true)
general_tab.appendRadioButton("import_annotations","Import Annotations","operation_type_group",false)

general_tab.appendHeader("Export Settings")
general_tab.appendSaveFileChooser("export_database_file","Export Database File","SQLite DB (*.db)","db","C:\\")
general_tab.appendCheckBox("export_markup_sets","Export Markup Sets",true)
general_tab.enabledOnlyWhenChecked("export_database_file","export_annotations")
general_tab.enabledOnlyWhenChecked("export_markup_sets","export_annotations")

general_tab.appendHeader("Import Settings")
general_tab.appendOpenFileChooser("import_database_file","Import Database File","SQLite DB (*.db)","db","C:\\")
general_tab.appendComboBox("annotation_matching_method","Match DB Records to Items Using",["GUID","MD5"])
general_tab.appendCheckBox("import_markup_sets","Import Markup Sets",true)
general_tab.appendCheckBox("append_markups","Append if Markup Set Already Exists",false)
general_tab.enabledOnlyWhenChecked("import_database_file","import_annotations")
general_tab.enabledOnlyWhenChecked("annotation_matching_method","import_annotations")
general_tab.enabledOnlyWhenChecked("append_markups","import_annotations")
general_tab.enabledOnlyWhenChecked("import_markup_sets","import_annotations")

dialog.validateBeforeClosing do |values|
	if values["export_annotations"]
		if values["export_database_file"].strip.empty?
			CommonDialogs.showWarning("Please provide an export database file.")
			next false
		end
	elsif values["import_annotations"]
		if values["import_database_file"].strip.empty? || java.io.File.new(values["import_database_file"]).exists == false
			CommonDialogs.showWarning("Please provide an existing import database file.")
			next false
		end
	end

	next true
end

dialog.display
if dialog.getDialogResult == true
	values = dialog.toMap
	import_annotations = values["import_annotations"]
	export_annotations = values["export_annotations"]

	ProgressDialog.forBlock do |pd|
		pd.setTitle("Annotation Export/Import")
		pd.setAbortButtonVisible(false)

		current_annotation_type = ""

		if export_annotations == true
			pd.logMessage("Operation: Export")
			export_database_file = values["export_database_file"]
			export_markup_sets = values["export_markup_sets"]

			repo = AnnotationRepository.new(export_database_file)
			repo.whenMessageLogged{|message| pd.logMessage(message)}
			repo.whenProgressUpdated do |current,total|
				pd.setMainProgress(current,total)
				pd.setMainStatus("Exporting #{current_annotation_type} #{current}/#{total}")
			end

			if export_markup_sets
				current_annotation_type = "Markups"
				repo.storeAllMarkupSets($current_case) if export_markup_sets
			end

			repo.close

		elsif import_annotations == true
			pd.logMessage("Operation: Import")
			import_database_file = values["import_database_file"]
			annotation_matching_method = AnnotationMatchingMethod::GUID
			if values["annotation_matching_method"] == "MD5"
				annotation_matching_method = AnnotationMatchingMethod::MD5
			end
			import_markup_sets = values["import_markup_sets"]
			append_markups = values["append_markups"]

			repo = AnnotationRepository.new(import_database_file)
			repo.whenMessageLogged{|message| pd.logMessage(message)}
			repo.whenProgressUpdated do |current,total|
				pd.setMainProgress(current,total)
				pd.setMainStatus("Importing #{current_annotation_type} #{current}/#{total}")
			end

			if import_markup_sets
				current_annotation_type = "Markups"
				repo.applyMarkupsFromDatabaseToCase($current_case,append_markups,annotation_matching_method)
			end

			repo.close
		end

		pd.setCompleted
	end
end