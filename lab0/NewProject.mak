# Generated by the VisualDSP++ IDDE

# Note:  Any changes made to this Makefile will be lost the next time the
# matching project file is loaded into the IDDE.  If you wish to preserve
# changes, rename this file and run it externally to the IDDE.

# The syntax of this Makefile is such that GNU Make v3.77 or higher is
# required.

# The current working directory should be the directory in which this
# Makefile resides.

# Supported targets:
#     NewProject_Debug
#     NewProject_Debug_clean

# Define this variable if you wish to run this Makefile on a host
# other than the host that created it and VisualDSP++ may be installed
# in a different directory.

ADI_DSP=C:\Program Files (x86)\Analog Devices\VisualDSP 5.1.2


# $VDSP is a gmake-friendly version of ADI_DIR

empty:=
space:= $(empty) $(empty)
VDSP_INTERMEDIATE=$(subst \,/,$(ADI_DSP))
VDSP=$(subst $(space),\$(space),$(VDSP_INTERMEDIATE))

RM=cmd /C del /F /Q

#
# Begin "NewProject_Debug" configuration
#

ifeq ($(MAKECMDGOALS),NewProject_Debug)

NewProject_Debug : ./Debug/NewProject.dxe 

./Debug/Edit1.doj :./Edit1.asm $(VDSP)/21k/include/def21060.h 
	@echo ".\Edit1.asm"
	$(VDSP)/easm21k.exe .\Edit1.asm -proc ADSP-21060 -file-attr ProjectName=NewProject -g -o .\Debug\Edit1.doj -MM

./Debug/NewProject.dxe :./NewProject.ldf ./Debug/Edit1.doj 
	@echo "Linking..."
	$(VDSP)/cc21k.exe .\Debug\Edit1.doj -T .\NewProject.ldf -L .\Debug -add-debug-libpaths -flags-link -od,.\Debug -o .\Debug\NewProject.dxe -proc ADSP-21060 -flags-link -MM

endif

ifeq ($(MAKECMDGOALS),NewProject_Debug_clean)

NewProject_Debug_clean:
	-$(RM) ".\Debug\Edit1.doj"
	-$(RM) ".\Debug\NewProject.dxe"
	-$(RM) ".\Debug\*.ipa"
	-$(RM) ".\Debug\*.opa"
	-$(RM) ".\Debug\*.ti"
	-$(RM) ".\Debug\*.pgi"
	-$(RM) ".\*.rbld"

endif


