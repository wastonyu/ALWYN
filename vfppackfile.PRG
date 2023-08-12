FUNCTION vfpZip 
LPARAMETERS xzip, xsource 
IF PARAMETERS() = 2
	SET PATH TO c:\windows 
	SET LIBRARY TO LOCFILE("vfpcompression.fll")
	
	&&建立壓縮文件
    = ZipOpen(FULLPATH(xzip))
    
    &&壓縮文件夾到ZIP文件
	= ZipFolder(xsource)

	&&關閉壓縮文件
	= ZipClose()
	
	SET LIBRARY TO
ENDIF 	

ENDFUNC 

FUNCTION VfpUnZip 
LPARAMETERS xzip, xtarget
IF PARAMETERS() = 2
	SET PATH TO c:\windows 
	SET LIBRARY TO LOCFILE("vfpcompression.fll")
	
	
    &&解壓縮文件夾到ZIP文件
	= UnZipQuick(xzip, xtarget)

	SET LIBRARY TO
ENDIF 	


