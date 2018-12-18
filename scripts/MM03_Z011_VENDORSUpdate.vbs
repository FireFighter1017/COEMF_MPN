If Not IsObject(application) Then
   Set SapGuiAuto  = GetObject("SAPGUI")
   Set application = SapGuiAuto.GetScriptingEngine
End If
If Not IsObject(connection) Then
   Set connection = application.Children(0)
End If
If Not IsObject(session) Then
   Set session    = connection.Children(0)
End If
If IsObject(WScript) Then
   WScript.ConnectObject session,     "on"
   WScript.ConnectObject application, "on"
End If
session.findById("wnd[0]").maximize
session.findById("wnd[0]/tbar[0]/okcd").text = "/nmm03"
session.findById("wnd[0]").sendVKey 0
session.findById("wnd[0]").sendVKey 4
session.findById("wnd[1]/usr/tabsG_SELONETABSTRIP/tabpTAB021/ssubSUBSCR_PRESEL:SAPLSDH4:0220/sub:SAPLSDH4:0220/ctxtG_SELFLD_TAB-LOW[4,24]").setFocus
session.findById("wnd[1]/usr/tabsG_SELONETABSTRIP/tabpTAB021/ssubSUBSCR_PRESEL:SAPLSDH4:0220/sub:SAPLSDH4:0220/ctxtG_SELFLD_TAB-LOW[4,24]").caretPosition = 0
session.findById("wnd[1]").sendVKey 4
session.findById("wnd[2]/usr/tabsG_SELONETABSTRIP/tabpTAB001/ssubSUBSCR_PRESEL:SAPLSDH4:0220/sub:SAPLSDH4:0220/txtG_SELFLD_TAB-LOW[5,24]").text = "5*"
session.findById("wnd[2]/usr/tabsG_SELONETABSTRIP/tabpTAB001/ssubSUBSCR_PRESEL:SAPLSDH4:0220/sub:SAPLSDH4:0220/txtG_SELFLD_TAB-LOW[5,24]").setFocus
session.findById("wnd[2]/usr/tabsG_SELONETABSTRIP/tabpTAB001/ssubSUBSCR_PRESEL:SAPLSDH4:0220/sub:SAPLSDH4:0220/txtG_SELFLD_TAB-LOW[5,24]").caretPosition = 2
session.findById("wnd[2]").sendVKey 0
session.findById("wnd[2]/usr/lbl[1,1]").setFocus
session.findById("wnd[2]/usr/lbl[1,1]").caretPosition = 0
session.findById("wnd[2]").sendVKey 14
session.findById("wnd[3]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[3,0]").select
session.findById("wnd[3]/usr/subSUBSCREEN_STEPLOOP:SAPLSPO5:0150/sub:SAPLSPO5:0150/radSPOPLI-SELFLAG[3,0]").setFocus
session.findById("wnd[3]/tbar[0]/btn[0]").press
session.findById("wnd[3]/usr/ctxtDY_PATH").setFocus
session.findById("wnd[3]/usr/ctxtDY_PATH").caretPosition = 0
session.findById("wnd[3]").sendVKey 4
session.findById("wnd[4]/usr/ctxtDY_PATH").text = "\\Client\C$\Users\u038pbel\Documents\Github\COEMF_MPN\scripts\srcData\"
session.findById("wnd[4]/usr/ctxtDY_PATH").caretPosition = 0
session.findById("wnd[4]").sendVKey 4
session.findById("wnd[5]/usr/ctxtDY_FILENAME").text = "Z011_VENDORS.htm"
session.findById("wnd[5]/usr/ctxtDY_FILENAME").caretPosition = 12
session.findById("wnd[5]/tbar[0]/btn[11]").press
session.findById("wnd[4]/usr/ctxtDY_PATH").text = ""
session.findById("wnd[4]/usr/ctxtDY_PATH").caretPosition = 0
session.findById("wnd[4]").sendVKey 4
session.findById("wnd[5]/tbar[0]/btn[11]").press
