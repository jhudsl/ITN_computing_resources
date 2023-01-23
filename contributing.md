## File name structure

1. filename.csv = The original data files that we had initially.
2. filename_new.csv = the new entries/modifications added to the original files. Such changes were performed in the `alldataFilesEditor.Rmd`.  (Overwriting the original file did not work since it kept adding the same row with new tool information every time it compiled the Rmd file.)
3. modifiled_filename.csv = the data files after preparing them for website view (keeping certain columns, removing others, hyperlinked, etc.). These were compiled in each of the different table's Rmd files and then we used the modified files (with all the editing) in the "All platforms" page. This allowed us to avoid copy pasting the same wrangling codes again in the "allTables.Rmd".

The workflow is basically this:
1. We add new/modify new/old entries in each datasets in the `alldataFilesEditor.Rmd` (filename.csv > filename_new.csv)
2. We wrangle each dataset and generate the modified datasets suitable for using with `DT::dataTable()` (filename_new.csv > modified_filename.csv).

