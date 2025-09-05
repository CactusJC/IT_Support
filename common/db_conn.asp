<%
' db_conn.asp
' Centralized database connection script.
Option Explicit

Dim conn

' --- IMPORTANT ---
' Replace "C:\path\to\your\database\support.mdb" with the actual path to your MDB file.
' The web server user (e.g., IUSR) needs read/write permissions on this file and its directory.
Dim dbPath
dbPath = Server.MapPath("/database/support.mdb") ' Assuming the database is in a 'database' folder in the web root.

' OLEDB Connection string for MS Access
Dim connStr
connStr = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & dbPath & ";"

Set conn = Server.CreateObject("ADODB.Connection")

On Error Resume Next
conn.Open connStr
If Err.Number <> 0 Then
    Response.Write "<h1>Database Connection Error</h1>"
    Response.Write "<p>Could not connect to the database. Please check the path and permissions.</p>"
    Response.Write "<p>Error: " & Err.Description & "</p>"
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
