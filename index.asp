<%@ Language=VBScript %>
<%
Option Explicit

' Database Connection
Dim conn, rs, sql, ticketNumber
Set conn = Server.CreateObject("ADODB.Connection")
conn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=\\123.457.nl\Klantensite\index\database.mdb;"

' Function to escape single quotes for SQL injection prevention
Function EscapeQuotes(str)
    EscapeQuotes = Replace(str, "'", "''")
End Function

' Handle form submissions
If Request.ServerVariables("REQUEST_METHOD") = "POST" Then
    Dim formType, issueType, description, roomNumber, phoneNumber, name, email, items, quantities, comments, whatToOrder, explanation
    formType = Request.Form("formType")
    
    If formType = "issue" Then
        issueType = Request.Form("issueType")
        description = EscapeQuotes(Request.Form("description"))
        roomNumber = EscapeQuotes(Request.Form("roomNumber"))
        phoneNumber = EscapeQuotes(Request.Form("phoneNumber"))
        name = EscapeQuotes(Request.Form("name"))
        email = EscapeQuotes(Request.Form("email"))
        
        ' Insert into Tickets table
        sql = "INSERT INTO Tickets (RequestType, IssueType, Description, RoomNumber, PhoneNumber, Name, Email, Timestamp) VALUES ('issue', '" & issueType & "', '" & description & "', '" & roomNumber & "', '" & phoneNumber & "', '" & name & "', '" & email & "', Now())"
        conn.Execute sql
        
        ' Retrieve the last inserted ticket number
        Set rs = conn.Execute("SELECT MAX(TicketNumber) AS LastTicket FROM Tickets")
        ticketNumber = rs("LastTicket")
        rs.Close
    ElseIf formType = "hardware" Then
        items = Request.Form("items")
        quantities = Request.Form("quantities")
        comments = EscapeQuotes(Request.Form("comments"))
        roomNumber = EscapeQuotes(Request.Form("roomNumber"))
        phoneNumber = EscapeQuotes(Request.Form("phoneNumber"))
        name = EscapeQuotes(Request.Form("name"))
        email = EscapeQuotes(Request.Form("email"))
        
        ' Insert into Tickets table
        sql = "INSERT INTO Tickets (RequestType, Comments, RoomNumber, PhoneNumber, Name, Email, Timestamp) VALUES ('hardware', '" & comments & "', '" & roomNumber & "', '" & phoneNumber & "', '" & name & "', '" & email & "', Now())"
        conn.Execute sql
        
        ' Retrieve the last inserted ticket number
        Set rs = conn.Execute("SELECT MAX(TicketNumber) AS LastTicket FROM Tickets")
        ticketNumber = rs("LastTicket")
        rs.Close
        
        ' Insert hardware items into a related table
        Dim itemArray, qtyArray, i
        itemArray = Split(items, ",")
        qtyArray = Split(quantities, ",")
        For i = 0 To UBound(itemArray)
            If Trim(itemArray(i)) <> "" Then
                sql = "INSERT INTO HardwareRequests (TicketNumber, ItemName, Quantity) VALUES (" & ticketNumber & ", '" & EscapeQuotes(itemArray(i)) & "', " & CInt(qtyArray(i)) & ")"
                conn.Execute sql
            End If
        Next
    ElseIf formType = "lim" Then
        whatToOrder = EscapeQuotes(Request.Form("whatToOrder"))
        explanation = EscapeQuotes(Request.Form("explanation"))
        roomNumber = EscapeQuotes(Request.Form("roomNumber"))
        phoneNumber = EscapeQuotes(Request.Form("phoneNumber"))
        name = EscapeQuotes(Request.Form("name"))
        email = EscapeQuotes(Request.Form("email"))
        
        ' Insert into Tickets table
        sql = "INSERT INTO Tickets (RequestType, WhatToOrder, Explanation, RoomNumber, PhoneNumber, Name, Email, Timestamp) VALUES ('lim', '" & whatToOrder & "', '" & explanation & "', '" & roomNumber & "', '" & phoneNumber & "', '" & name & "', '" & email & "', Now())"
        conn.Execute sql
        
        ' Retrieve the last inserted ticket number
        Set rs = conn.Execute("SELECT MAX(TicketNumber) AS LastTicket FROM Tickets")
        ticketNumber = rs("LastTicket")
        rs.Close
    End If
    
    ' Redirect to confirmation page
    Response.Redirect "index.asp?confirmation=" & ticketNumber
End If

' Determine which page to display
Dim page
page = Request.QueryString("page")
If page = "" Then page = "main"
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IT Support Request System</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #F8F9FA;
            color: #212529;
            margin: 0;
            padding: 0;
        }
        .header {
            background-color: #007BFF;
            color: white;
            padding: 10px;
            text-align: center;
        }
        .content {
            padding: 20px;
            max-width: 800px;
            margin: 0 auto;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group textarea,
        .form-group select {
            width: 100%;
            padding: 8px;
            border: 1px solid #CED4DA;
            border-radius: 4px;
            box-sizing: border-box;
        }
        .form-group input[type="checkbox"] {
            margin-right: 10px;
        }
        .form-group .checkbox-group {
            margin-bottom: 10px;
        }
        .form-group .checkbox-group input[type="text"] {
            width: 80px;
            margin-left: 10px;
        }
        .submit-btn {
            background-color: #007BFF;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }
        .submit-btn:hover {
            background-color: #0056b3;
        }
        .footer {
            background-color: #007BFF;
            color: white;
            padding: 10px;
            text-align: center;
            position: fixed;
            bottom: 0;
            width: 100%;
        }
        a {
            color: #007BFF;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
        .error {
            color: red;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>IT Support Request System</h1>
    </div>
    <div class="content">
        <%
        If page = "main" Then
        %>
            <h2>Welcome</h2>
            <p>Please select the type of request you would like to submit below:</p>
            <ul>
                <li><a href="index.asp?page=issue">Report an Issue</a></li>
                <li><a href="index.asp?page=hardware">Request Hardware</a></li>
                <li><a href="index.asp?page=lim">Request LIM</a></li>
            </ul>
        <%
        ElseIf page = "issue" Then
        %>
            <h2>Report an Issue Form</h2>
            <form method="post" action="index.asp" onsubmit="return validateIssueForm()">
                <input type="hidden" name="formType" value="issue">
                <div class="form-group">
                    <label for="issueType">Issue Type</label>
                    <select id="issueType" name="issueType" required>
                        <option value="">Select an issue type</option>
                        <option value="disruption">Disruption</option>
                        <option value="complaint">Complaint</option>
                        <option value="defect">Defect</option>
                        <option value="servicedesk">Servicedesk</option>
                        <option value="request">Request</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="description">Describe the Situation</label>
                    <textarea id="description" name="description" rows="5" required></textarea>
                </div>
                <div class="form-group">
                    <label for="roomNumber">Room Number</label>
                    <input type="text" id="roomNumber" name="roomNumber" required>
                </div>
                <div class="form-group">
                    <label for="phoneNumber">Phone Number</label>
                    <input type="text" id="phoneNumber" name="phoneNumber" required>
                </div>
                <div class="form-group">
                    <label for="name">Name</label>
                    <input type="text" id="name" name="name" required>
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <button type="submit" class="submit-btn">Submit</button>
            </form>
        <%
        ElseIf page = "hardware" Then
        %>
            <h2>Request Hardware Form</h2>
            <form method="post" action="index.asp" onsubmit="return validateHardwareForm()">
                <input type="hidden" name="formType" value="hardware">
                <div class="form-group">
                    <label>Hardware Items</label>
                    <div class="checkbox-group">
                        <input type="checkbox" name="item1" value="Keyboard" onchange="toggleQuantity(this, 'qty1')"> Keyboard
                        <input type="text" id="qty1" name="qty1" size="3" placeholder="Qty" disabled>
                    </div>
                    <div class="checkbox-group">
                        <input type="checkbox" name="item2" value="Mouse" onchange="toggleQuantity(this, 'qty2')"> Mouse
                        <input type="text" id="qty2" name="qty2" size="3" placeholder="Qty" disabled>
                    </div>
                    <div class="checkbox-group">
                        <input type="checkbox" name="item3" value="Monitor" onchange="toggleQuantity(this, 'qty3')"> Monitor
                        <input type="text" id="qty3" name="qty3" size="3" placeholder="Qty" disabled>
                    </div>
                </div>
                <div class="form-group">
                    <label for="comments">Additional Comments</label>
                    <textarea id="comments" name="comments" rows="5"></textarea>
                </div>
                <div class="form-group">
                    <label for="roomNumber">Room Number</label>
                    <input type="text" id="roomNumber" name="roomNumber" required>
                </div>
                <div class="form-group">
                    <label for="phoneNumber">Phone Number</label>
                    <input type="text" id="phoneNumber" name="phoneNumber" required>
                </div>
                <div class="form-group">
                    <label for="name">Name</label>
                    <input type="text" id="name" name="name" required>
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <input type="hidden" id="items" name="items">
                <input type="hidden" id="quantities" name="quantities">
                <button type="submit" class="submit-btn">Submit</button>
            </form>
        <%
        ElseIf page = "lim" Then
        %>
            <h2>Request LIM Form</h2>
            <form method="post" action="index.asp" onsubmit="return validateLimForm()">
                <input type="hidden" name="formType" value="lim">
                <div class="form-group">
                    <label for="whatToOrder">What Would You Like to Order?</label>
                    <textarea id="whatToOrder" name="whatToOrder" rows="5" required></textarea>
                </div>
                <div class="form-group">
                    <label for="explanation">Explanation/Motivation</label>
                    <textarea id="explanation" name="explanation" rows="5" required></textarea>
                </div>
                <div class="form-group">
                    <label for="roomNumber">Room Number</label>
                    <input type="text" id="roomNumber" name="roomNumber" required>
                </div>
                <div class="form-group">
                    <label for="phoneNumber">Phone Number</label>
                    <input type="text" id="phoneNumber" name="phoneNumber" required>
                </div>
                <div class="form-group">
                    <label for="name">Name</label>
                    <input type="text" id="name" name="name" required>
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <button type="submit" class="submit-btn">Submit</button>
            </form>
        <%
        ElseIf page = "confirmation" Then
            Dim confirmationTicket
            confirmationTicket = Request.QueryString("confirmation")
        %>
            <h2>Confirmation</h2>
            <p>Your request has been successfully submitted. Your ticket number is: <strong><%=confirmationTicket%></strong>. Please note this number for future reference.</p>
            <a href="index.asp">Back to Home</a>
        <%
        End If
        %>
    </div>
    <div class="footer">
        <p>IT Department, Phone: 1234</p>
    </div>

    <!-- JavaScript for Frontend Enhancements -->
    <script type="text/javascript">
        // Toggle quantity input based on checkbox state
        function toggleQuantity(checkbox, qtyId) {
            var qtyInput = document.getElementById(qtyId);
            qtyInput.disabled = !checkbox.checked;
            if (!checkbox.checked) {
                qtyInput.value = '';
            }
        }

        // Validate Issue Form
        function validateIssueForm() {
            var issueType = document.getElementById('issueType').value;
            var description = document.getElementById('description').value.trim();
            var roomNumber = document.getElementById('roomNumber').value.trim();
            var phoneNumber = document.getElementById('phoneNumber').value.trim();
            var name = document.getElementById('name').value.trim();
            var email = document.getElementById('email').value.trim();
            var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

            if (!issueType) {
                alert('Please select an issue type.');
                return false;
            }
            if (!description) {
                alert('Please describe the situation.');
                return false;
            }
            if (!roomNumber || !phoneNumber || !name || !email) {
                alert('Please fill in all required fields.');
                return false;
            }
            if (!emailRegex.test(email)) {
                alert('Please enter a valid email address.');
                return false;
            }
            return true;
        }

        // Validate Hardware Form
        function validateHardwareForm() {
            var checkboxes = document.querySelectorAll('input[type="checkbox"]:checked');
            var items = [];
            var quantities = [];
            var roomNumber = document.getElementById('roomNumber').value.trim();
            var phoneNumber = document.getElementById('phoneNumber').value.trim();
            var name = document.getElementById('name').value.trim();
            var email = document.getElementById('email').value.trim();
            var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

            if (checkboxes.length === 0) {
                alert('Please select at least one hardware item.');
                return false;
            }

            checkboxes.forEach(function(checkbox) {
                var qtyId = 'qty' + checkbox.name.slice(-1);
                var qty = document.getElementById(qtyId).value.trim();
                if (!qty || isNaN(qty) || qty <= 0) {
                    alert('Please enter a valid quantity for ' + checkbox.value + '.');
                    return false;
                }
                items.push(checkbox.value);
                quantities.push(qty);
            });

            if (!roomNumber || !phoneNumber || !name || !email) {
                alert('Please fill in all required fields.');
                return false;
            }
            if (!emailRegex.test(email)) {
                alert('Please enter a valid email address.');
                return false;
            }

            document.getElementById('items').value = items.join(',');
            document.getElementById('quantities').value = quantities.join(',');
            return true;
        }

        // Validate LIM Form
        function validateLimForm() {
            var whatToOrder = document.getElementById('whatToOrder').value.trim();
            var explanation = document.getElementById('explanation').value.trim();
            var roomNumber = document.getElementById('roomNumber').value.trim();
            var phoneNumber = document.getElementById('phoneNumber').value.trim();
            var name = document.getElementById('name').value.trim();
            var email = document.getElementById('email').value.trim();
            var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

            if (!whatToOrder || !explanation) {
                alert('Please fill in both the order details and explanation.');
                return false;
            }
            if (!roomNumber || !phoneNumber || !name || !email) {
                alert('Please fill in all required fields.');
                return false;
            }
            if (!emailRegex.test(email)) {
                alert('Please enter a valid email address.');
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
<%
' Clean up database connection
conn.Close
Set conn = Nothing
%>