VERSION 5.00
Object = "{248DD890-BB45-11CF-9ABC-0080C7E7B78D}#1.0#0"; "mswinsck.ocx"
Begin VB.Form Form1 
   BackColor       =   &H00808080&
   Caption         =   "JB's Wifi Robot Controller"
   ClientHeight    =   3705
   ClientLeft      =   4185
   ClientTop       =   1695
   ClientWidth     =   4680
   Enabled         =   0   'False
   FillColor       =   &H00FFFFFF&
   Icon            =   "Form1.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   9276.992
   ScaleMode       =   0  'User
   ScaleWidth      =   4680
   WhatsThisHelp   =   -1  'True
   Begin VB.Timer call_timer 
      Left            =   4080
      Top             =   1920
   End
   Begin VB.CommandButton Command1 
      Caption         =   "CON"
      Height          =   495
      Left            =   3600
      TabIndex        =   8
      Top             =   3120
      Width           =   855
   End
   Begin MSWinsockLib.Winsock sock 
      Left            =   4080
      Top             =   2520
      _ExtentX        =   741
      _ExtentY        =   741
      _Version        =   393216
   End
   Begin VB.TextBox lbladdress 
      Alignment       =   2  'Center
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   8.25
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   0
      TabIndex        =   6
      Text            =   "192.168.1.1"
      Top             =   360
      Width           =   1335
   End
   Begin VB.CommandButton cmd_right 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      DownPicture     =   "Form1.frx":164A
      Height          =   615
      Left            =   2760
      MaskColor       =   &H00808080&
      Picture         =   "Form1.frx":1D94
      Style           =   1  'Graphical
      TabIndex        =   4
      Top             =   2160
      UseMaskColor    =   -1  'True
      Width           =   735
   End
   Begin VB.CommandButton cmd_left 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      DownPicture     =   "Form1.frx":24DE
      Height          =   615
      Left            =   1320
      MaskColor       =   &H00808080&
      Picture         =   "Form1.frx":2C28
      Style           =   1  'Graphical
      TabIndex        =   3
      Top             =   2160
      UseMaskColor    =   -1  'True
      Width           =   735
   End
   Begin VB.CommandButton cmd_up 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      DownPicture     =   "Form1.frx":3372
      Height          =   615
      Left            =   2040
      MaskColor       =   &H00808080&
      Picture         =   "Form1.frx":3AD4
      Style           =   1  'Graphical
      TabIndex        =   2
      Top             =   1560
      UseMaskColor    =   -1  'True
      Width           =   735
   End
   Begin VB.PictureBox Picture1 
      BackColor       =   &H00808080&
      BorderStyle     =   0  'None
      Height          =   1215
      Left            =   1200
      Picture         =   "Form1.frx":4236
      ScaleHeight     =   1215
      ScaleWidth      =   2295
      TabIndex        =   1
      Top             =   240
      Width           =   2295
   End
   Begin VB.CommandButton cmd_down 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      DownPicture     =   "Form1.frx":C238
      Height          =   615
      Left            =   2040
      MaskColor       =   &H00808080&
      Picture         =   "Form1.frx":C99A
      Style           =   1  'Graphical
      TabIndex        =   0
      Top             =   2760
      UseMaskColor    =   -1  'True
      Width           =   735
   End
   Begin VB.Label Label2 
      BackColor       =   &H80000010&
      Caption         =   "see config.txt"
      ForeColor       =   &H8000000E&
      Height          =   240
      Left            =   120
      TabIndex        =   12
      Top             =   720
      Width           =   1095
   End
   Begin VB.Label Label7 
      BackColor       =   &H80000010&
      Caption         =   "T: connect"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H8000000E&
      Height          =   240
      Left            =   3480
      TabIndex        =   11
      Top             =   840
      Width           =   1095
   End
   Begin VB.Label Label6 
      BackColor       =   &H80000010&
      Caption         =   "H: horn"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H8000000E&
      Height          =   240
      Left            =   3480
      TabIndex        =   10
      Top             =   480
      Width           =   1095
   End
   Begin VB.Label Label5 
      Caption         =   "Label5"
      Height          =   735
      Left            =   240
      TabIndex        =   9
      Top             =   1800
      Width           =   975
   End
   Begin VB.Label Label3 
      BackColor       =   &H80000010&
      Caption         =   "Esc = Exit"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H8000000E&
      Height          =   360
      Left            =   45
      TabIndex        =   7
      Top             =   3360
      Width           =   1095
   End
   Begin VB.Label Label1 
      BackColor       =   &H80000010&
      Caption         =   "Address:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   0
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H8000000E&
      Height          =   360
      Left            =   50
      TabIndex        =   5
      Top             =   40
      Width           =   1095
   End
End
Attribute VB_Name = "Form1"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Public direction As String
Public ttime As Integer
Public address As String
Public upstatus, downstatus, leftstatus, rightstatus, hornstatus As Integer
Public output As Integer


Private Sub call_timer_Timer()
    Call motion("manual", upstatus + downstatus + rightstatus + leftstatus + hornstatus)
    'Calls motion module.  Lets it know manual driving and what value to output to the
    'parallel port
End Sub

Private Sub Command1_Click()
  If sock.State = sckClosed Then ' if the socket is closed
    sock.RemoteHost = lbladdress.Text ' set server adress
    sock.RemotePort = "1500" ' set server port
    Label5.Caption = "Connected"
    sock.Connect ' start connection attempt
  Else ' if the socket is open
    sock.Close ' close it
    Label5.Caption = "Not Connected"
  End If
End Sub

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)
    'Detects if control keys are pressed
    If KeyCode = vbKeyEscape Then End 'Exits
    If KeyCode = vbKeyT Then Call Command1_Click
    If KeyCode = vbKeyUp Or KeyCode = vbKeyW Then: cmd_up.BackColor = &HFF0000: cmd_up.Picture = cmd_up.DownPicture: upstatus = 1
    'If up arrow is pressed or W then change pictures (make it blue) and change upstatus.
    If KeyCode = vbKeyDown Or KeyCode = vbKeyS Then cmd_down.BackColor = &HFF0000: cmd_down.Picture = cmd_down.DownPicture: downstatus = 2
    'If down arrow is pressed or S then change pictures (make it blue) and change downstatus.
    If KeyCode = vbKeyLeft Or KeyCode = vbKeyA Then cmd_left.BackColor = &HFF0000: cmd_left.Picture = cmd_left.DownPicture: rightstatus = 4
    'If left arrow is pressed or A then change pictures (make it blue) and change rightstatus.
    If KeyCode = vbKeyRight Or KeyCode = vbKeyD Then cmd_right.BackColor = &HFF0000: cmd_right.Picture = cmd_right.DownPicture: leftstatus = 8
    'If right arrow is pressed or D then change pictures (make it blue) and change leftstatus.
    If KeyCode = vbKeyH Then hornstatus = 32
End Sub

Private Sub Form_KeyUp(KeyCode As Integer, Shift As Integer)
    'Stops output to that direction when key is lifted.
    'Changes pictures back to unactivated (none-blue).
    If KeyCode = vbKeyUp Or KeyCode = vbKeyW Then cmd_up.BackColor = &HFFFFFF: cmd_up.Picture = cmd_up.DisabledPicture: upstatus = 0
    If KeyCode = vbKeyDown Or KeyCode = vbKeyS Then cmd_down.BackColor = &HFFFFFF: cmd_down.Picture = cmd_down.DisabledPicture: downstatus = 0
    If KeyCode = vbKeyLeft Or KeyCode = vbKeyA Then cmd_left.BackColor = &HFFFFFF: cmd_left.Picture = cmd_left.DisabledPicture: rightstatus = 0
    If KeyCode = vbKeyRight Or KeyCode = vbKeyD Then cmd_right.BackColor = &HFFFFFF: cmd_right.Picture = cmd_right.DisabledPicture: leftstatus = 0
    If KeyCode = vbKeyH Then hornstatus = 0
End Sub

Private Sub Form_Load()
    Dim line As String
    'Stores {Arrow with white} pic in .DisabledPicture for each button
    cmd_up.DisabledPicture = cmd_up.Picture
    cmd_down.DisabledPicture = cmd_down.Picture
    cmd_left.DisabledPicture = cmd_left.Picture
    cmd_right.DisabledPicture = cmd_right.Picture
    'Following Opens Config.txt and collect Parallel Port Address and Refresh Rate
    Open CurDir & "\config.txt" For Input As #1
    Line Input #1, line
    Line Input #1, line
    address = line 'Sets parallel port address
    lbladdress.Text = address 'displays address
    call_timer.Interval = 5
    
End Sub
Private Sub sock_Close()
    sock.Close ' has to be
End Sub
  
Private Sub sock_Error(ByVal Number As Integer, Description As String, ByVal Scode As Long, ByVal Source As String, ByVal HelpFile As String, ByVal HelpContext As Long, CancelDisplay As Boolean)
    MsgBox "Socket Error " & Number & ": " & Description
    sock.Close ' close the erraneous connection
End Sub

'Motion Executor
Sub motion(direction As String, ttime As Integer)
    address = Form1.address
    Select Case direction
    Case 1 To 10
    Case "manual"
    'If manual driving, parallel port output required for direction has already
    'been calculated, so output value passed to ttime
    output = ttime
    Case "FF"
        output = 1
    Case "BB"
        output = 2
    Case "RR"
        output = 8
    Case "LL"
        output = 4
    Case "FR"
        output = 9
    Case "FL"
        output = 5
    Case "BR"
        output = 10
    Case "BL"
        output = 6
    Case "SS"
        output = 0
    End Select
    Rem vbOut address, output
    'sock.SendData output & Chr(0)
    If sock.State = sckConnected Then
     If output = &HC Or output = &H1C Then output = output - 8
     If output = &H3 Or output = &H13 Then output = output - 2
     sock.SendData Chr(output + 1) & Chr(0)
      Label5.Caption = Chr(output + 1) & Chr(0)
    Else
        Label5.Caption = "NOT sending data"
    End If
End Sub
