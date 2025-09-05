<%
' db_conn.asp
' Centralized database connection script.
Option Explicit

Dim conn

' --- Verbinding maken met de database ---
' Het pad hieronder is gebaseerd op de input van de gebruiker.
Set conn = Server.CreateObject("ADODB.Connection")

On Error Resume Next
' Gebruik het directe UNC pad zoals door de gebruiker aangegeven. Let op: het dollarteken ($) in het pad kan soms problemen geven.
conn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=\\metro.applic.mjeltechnologies.nl\pg11_inetmb_kalibratie$\Klantensite\ITSupport\database\support.mdb;"

If Err.Number <> 0 Then
    Response.Write "<h1>Database Connection Error</h1>"
    Response.Write "<p>Could not connect to the database. This is likely a **permissions issue** on the network share or an **incorrect path**.</p>"
    Response.Write "<p>Please ensure the IIS Application Pool user has read/write access to the network folder and the database file.</p>"
    Response.Write "<p><b>Error Description:</b> " & Err.Description & "</p>"
    Response.End
End If
On Error GoTo 0

' Function to safely handle SQL inputs and prevent basic SQL injection.
Function SafeSQL(str)
    If IsNull(str) Or str = "" Then
        SafeSQL = ""
    Else
        SafeSQL = Replace(str, "'", "''")
    End If
End Function
%>
