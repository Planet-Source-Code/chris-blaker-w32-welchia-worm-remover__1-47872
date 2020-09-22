VERSION 5.00
Begin VB.Form frmMain 
   BackColor       =   &H00FFFFFF&
   BorderStyle     =   1  'Fixed Single
   Caption         =   "W32.WELCHIA.WORM - Remover"
   ClientHeight    =   3262
   ClientLeft      =   42
   ClientTop       =   364
   ClientWidth     =   5474
   BeginProperty Font 
      Name            =   "Arial"
      Size            =   8
      Charset         =   0
      Weight          =   400
      Underline       =   0   'False
      Italic          =   0   'False
      Strikethrough   =   0   'False
   EndProperty
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   3262
   ScaleWidth      =   5474
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton cmdExit 
      BackColor       =   &H00E0E0E0&
      Caption         =   "&Exit"
      Height          =   392
      Left            =   2898
      Style           =   1  'Graphical
      TabIndex        =   4
      Top             =   2646
      Width           =   1148
   End
   Begin VB.CommandButton cmdBegin 
      BackColor       =   &H00E0E0E0&
      Caption         =   "&Begin"
      Height          =   392
      Left            =   4158
      Style           =   1  'Graphical
      TabIndex        =   3
      Top             =   2646
      Width           =   1148
   End
   Begin VB.PictureBox Picture1 
      AutoSize        =   -1  'True
      BorderStyle     =   0  'None
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   588
      Left            =   126
      Picture         =   "frmMain.frx":1AFA
      ScaleHeight     =   588
      ScaleWidth      =   1792
      TabIndex        =   0
      Top             =   126
      Width           =   1792
   End
   Begin VB.Label Label7 
      BackStyle       =   0  'Transparent
      Caption         =   "Click ""Begin"" to start removal."
      ForeColor       =   &H00735937&
      Height          =   196
      Left            =   252
      TabIndex        =   9
      Top             =   2730
      Width           =   4928
   End
   Begin VB.Label Label6 
      BackStyle       =   0  'Transparent
      Caption         =   "2. The second part will launch, and the virus will be removed."
      ForeColor       =   &H00735937&
      Height          =   196
      Left            =   252
      TabIndex        =   8
      Top             =   2016
      Width           =   4928
   End
   Begin VB.Label Label5 
      BackStyle       =   0  'Transparent
      Caption         =   "And the system will re-boot."
      ForeColor       =   &H00735937&
      Height          =   196
      Left            =   400
      TabIndex        =   7
      Top             =   1600
      Width           =   4928
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "1. Registry keys from the virus will be removed."
      ForeColor       =   &H00735937&
      Height          =   196
      Left            =   252
      TabIndex        =   6
      Top             =   1386
      Width           =   4928
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Removal of this worm, will happen in 2 (two) stages."
      ForeColor       =   &H00735937&
      Height          =   196
      Left            =   252
      TabIndex        =   5
      Top             =   1008
      Width           =   4928
   End
   Begin VB.Shape Shape1 
      BorderColor     =   &H00735937&
      Height          =   1526
      Left            =   126
      Top             =   882
      Width           =   5180
   End
   Begin VB.Label Label2 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "Programmed by: Christopher J. Bradley."
      ForeColor       =   &H00808080&
      Height          =   196
      Left            =   2142
      TabIndex        =   2
      Top             =   450
      Width           =   2674
   End
   Begin VB.Label Label1 
      AutoSize        =   -1  'True
      BackStyle       =   0  'Transparent
      Caption         =   "w32.welchia.worm remover for Windows."
      BeginProperty Font 
         Name            =   "Arial"
         Size            =   8
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00735937&
      Height          =   196
      Left            =   2142
      TabIndex        =   1
      Top             =   196
      Width           =   3220
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False

Private Sub cmdBegin_Click()
    Dim Zero, hKey As Long
    Dim AddAppPath As String
    Dim cExitWindows As New clsExitWindows
    
    AddAppPath = App.Path & "\" & App.EXEName & ".exe"
    RegOpenKeyEx HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion\Run", Zero, KEY_ALL_ACCESS, hKey
    CreateNewKey "", hKey
    SetKeyValue HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion\Run", "welchia remover", Addtoreg, REG_SZ  ' Add the program to the registry so it will perform it's second task after reboot
    DeleteValue HKEY_LOCAL_MACHINE, "\SYSTEM\CurrentControlSet\Services\", "RpcPatch"  ' Remove the virus from the registry.
    DeleteValue HKEY_LOCAL_MACHINE, "\SYSTEM\CurrentControlSet\Services\", "RpcTftpd"  ' Remove the virus from the registry.
    SaveSetting App.Title, "BOOTED", "Value", "1"   ' Change the registry option, so that the program will know to perform it's second task after re-booting.
    
    MsgBox "Virus registry key's sucessfully removed, the system will now restart.", vbInformation, "Sucess!"   ' Just tell the user what we've done.
    cExitWindows.ExitWindows WE_REBOOT  ' Reboot the pc.
End Sub

Private Sub cmdExit_Click()
Unload Me ' End the program and whatever.
End
End Sub

Private Sub Form_Load()
On Error Resume Next
cmdBegin.Tag = GetSetting(App.Title, "BOOTED", "Value")
If cmdBegin.Tag = "1" Then  ' If the application has already done the first part, proceed to the next.
    Me.Hide
    
    Kill "C:\WINDOWS\SYSTEM32\wins\svchost.exe"  '----|
    Kill "C:\WINDOWS\SYSTEM32\wins\dllhost.exe"  '----| Remove the virus from it's folders (WinXP)
    
    Kill "C:\WINDOWS\SYSTEM\wins\svchost.exe"    '----|
    Kill "C:\WINDOWS\SYSTEM\wins\dllhost.exe"    '----| Remove the virus from it's folders (Win9x, ME)
    
    Kill "C:\WINNT\SYSTEM32\wins\svchost.exe"    '----|
    Kill "C:\WINNT\SYSTEM32\wins\dllhost.exe"    '----| Remove the virus from it's folders (WinNT/2000)

    
    DeleteValue HKEY_LOCAL_MACHINE, "Software\Microsoft\Windows\CurrentVersion\Run", "welchia remover"
    SaveSetting App.Title, "BOOTED", "Value", "0"   ' Reset the registry setting so the program can be run again.
    
    MsgBox "Virus has been sucessfully removed.", vbInformation, "Operation Complete."  ' Inform the user that the virus has been removed.
    Unload Me   ' I usually use the 'unload me' as well as 'end' because sometimes an illegal operation can occure when you just use 'end'.
    End
Else    ' If there is nothing to indicate that the program should perform it's second task, than just proceed as normal.
    Exit Sub
End If
End Sub

