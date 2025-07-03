
# SAP2SDS

Migration of archaeological stone artefact datasets from SAP to SDS recording scheme

The workflow consists of four consecutive R-Scripts:

1) 01_Read_SAP_Data_single_file
2) 02_Convert_SAP-to-SDS
3) 03_SDS_analysis_test
4) 04_Evaluation

a) Read txt-File in Fixed-With-Format (FWF) like LW8.txt (Folder "data-raw") to data.frame (e.g. "LW8")

b) Convert data.frame with SAP variables & attributes to SDS format and export CSV file

c) Use "look_up_everything" function from R-Package SDSanalysis to "translate" numeric codes to written attribute descriptions

d) Calculate some basic statistics for important variables to access the quality of the conversion, export report on statistics to txt file


