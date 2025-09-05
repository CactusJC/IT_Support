<!-- #include file="common/header.asp" -->

<h2>Storing of Probleem Melden</h2>

<div class="form-container">
    <form action="actions/submit_ticket.asp" method="post" id="ticketForm">
        <div class="form-group">
            <label for="contactNaam">Uw Volledige Naam</label>
            <input type="text" id="contactNaam" name="contactNaam" required>
        </div>
        <div class="form-group">
            <label for="email">Uw E-mailadres</label>
            <input type="email" id="email" name="email" required>
        </div>
        <div class="form-group">
            <label for="afdeling">Uw Afdeling</label>
            <input type="text" id="afdeling" name="afdeling" required>
        </div>
        <div class="form-group">
            <label for="locatie">Locatie (bv. Gebouw, Kamernummer)</label>
            <input type="text" id="locatie" name="locatie" required>
        </div>
        <div class="form-group">
            <label for="omschrijving">Omschrijving van de Storing</label>
            <textarea id="omschrijving" name="omschrijving" rows="6" required></textarea>
        </div>
        <button type="submit" class="btn">Meld Storing</button>
    </form>
</div>

<!-- #include file="common/footer.asp" -->
