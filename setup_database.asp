<!-- #include file="common/db_conn.asp" -->
<!DOCTYPE html>
<html lang="nl">
<head>
    <meta charset="UTF-8">
    <title>Database Setup</title>
    <style>
        body { font-family: sans-serif; line-height: 1.6; padding: 20px; }
        p { margin: 5px 0; }
        .success { color: green; }
        .error { color: red; }
        .warning { color: orange; }
        .info { color: blue; }
        .important { font-weight: bold; color: red; border: 1px solid red; padding: 10px; margin-top: 20px;}
    </style>
</head>
<body>
    <h1>Database Setup Script</h1>
    <p>Dit script controleert en creëert de benodigde tabellen in uw database.</p>
    <hr>
<%
' Functie om te controleren of een tabel bestaat
Function TableExists(tableName)
    On Error Resume Next
    conn.Execute("SELECT TOP 1 * FROM " & tableName)
    If Err.Number = 0 Then
        TableExists = True
    Else
        TableExists = False
    End If
    Err.Clear
    On Error GoTo 0
End Function

Dim sql

' --- Tabel: Tickets ---
Response.Write "<h2>1. Tabel 'Tickets'</h2>"
If TableExists("Tickets") Then
    Response.Write "<p class='warning'>Tabel 'Tickets' bestaat al. Actie overgeslagen.</p>"
Else
    sql = "CREATE TABLE Tickets (" & _
          "TicketID COUNTER PRIMARY KEY, " & _
          "TypeAanvraag VARCHAR(50), " & _
          "Beschrijving MEMO, " & _
          "Status VARCHAR(50), " & _
          "DatumIngediend DATETIME, " & _
          "DatumAfgehandeld DATETIME, " & _
          "Afdeling VARCHAR(100), " & _
          "Gebruiker VARCHAR(100), " & _
          "Contactpersoon VARCHAR(100), " & _
          "Locatie VARCHAR(255), " & _
          "Goedkeuringsstatus VARCHAR(50))"

    On Error Resume Next
    conn.Execute(sql)
    If Err.Number = 0 Then
        Response.Write "<p class='success'>Tabel 'Tickets' succesvol aangemaakt.</p>"
    Else
        Response.Write "<p class='error'>FOUT bij aanmaken 'Tickets': " & Err.Description & "</p>"
    End If
    Err.Clear
    On Error GoTo 0
End If

' --- Tabel: HardwareRequests ---
Response.Write "<h2>2. Tabel 'HardwareRequests'</h2>"
If TableExists("HardwareRequests") Then
    Response.Write "<p class='warning'>Tabel 'HardwareRequests' bestaat al. Actie overgeslagen.</p>"
Else
    ' OPMERKING: FOREIGN KEY constraints worden niet ondersteund in een CREATE TABLE statement in Jet SQL.
    ' De applicatielogica zorgt voor de correcte relatie.
    sql = "CREATE TABLE HardwareRequests (" & _
          "RequestID COUNTER PRIMARY KEY, " & _
          "TicketID LONG, " & _
          "ProductCategorie VARCHAR(100), " & _
          "ProductType VARCHAR(100), " & _
          "Motivatie MEMO, " & _
          "KostenIndicatie CURRENCY)"

    On Error Resume Next
    conn.Execute(sql)
    If Err.Number = 0 Then
        Response.Write "<p class='success'>Tabel 'HardwareRequests' succesvol aangemaakt.</p>"
    Else
        Response.Write "<p class='error'>FOUT bij aanmaken 'HardwareRequests': " & Err.Description & "</p>"
    End If
    Err.Clear
    On Error GoTo 0
End If

' --- Tabel: Users ---
Response.Write "<h2>3. Tabel 'Users'</h2>"
If TableExists("Users") Then
    Response.Write "<p class='warning'>Tabel 'Users' bestaat al. Actie overgeslagen.</p>"
Else
    sql = "CREATE TABLE Users (" & _
          "UserID COUNTER PRIMARY KEY, " & _
          "Naam VARCHAR(100), " & _
          "Afdeling VARCHAR(100), " & _
          "Email VARCHAR(100))"

    On Error Resume Next
    conn.Execute(sql)
    If Err.Number = 0 Then
        Response.Write "<p class='success'>Tabel 'Users' succesvol aangemaakt.</p>"
        ' Voeg voorbeelddata toe
        conn.Execute("INSERT INTO Users (Naam, Afdeling, Email) VALUES ('Jan Jansen', 'Finance', 'jan.jansen@example.com')")
        conn.Execute("INSERT INTO Users (Naam, Afdeling, Email) VALUES ('Piet Pietersen', 'Marketing', 'piet.pietersen@example.com')")
        Response.Write "<p class='info'>Voorbeelddata toegevoegd aan 'Users' tabel.</p>"
    Else
        Response.Write "<p class='error'>FOUT bij aanmaken 'Users': " & Err.Description & "</p>"
    End If
    Err.Clear
    On Error GoTo 0
End If

Response.Write "<hr><h3>Setup Voltooid</h3>"
Response.Write "<div class='important'>BELANGRIJK: Verwijder dit bestand (setup_database.asp) nu van de server om veiligheidsredenen.</div>"

%>
</body>
</html>
