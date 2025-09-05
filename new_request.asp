<!-- #include file="common/header.asp" -->

<h2>Nieuwe Hardware/Software Aanvragen</h2>

<div class="form-container">
    <form action="actions/submit_request.asp" method="post" id="requestForm">

        <h4>Contact- en Afleverinformatie</h4>
        <div class="form-group">
            <label for="contactNaam">Uw Naam (Contactpersoon)</label>
            <input type="text" id="contactNaam" name="contactNaam" required>
        </div>
        <div class="form-group">
            <label for="email">Uw E-mailadres</label>
            <input type="email" id="email" name="email" required>
        </div>
         <div class="form-group">
            <label for="gebruiker">Voor welke gebruiker is deze bestelling?</label>
            <input type="text" id="gebruiker" name="gebruiker" required>
        </div>
        <div class="form-group">
            <label for="afdeling">Afdeling</label>
            <input type="text" id="afdeling" name="afdeling" required>
        </div>
        <div class="form-group">
            <label for="locatie">Afleverlocatie (Land, Plaats, Terrein, Gebouw, Kamer)</label>
            <input type="text" id="locatie" name="locatie" required>
        </div>

        <hr style="margin: 2rem 0;">

        <h4>Aanvraag Details</h4>
        <div class="form-group">
            <label for="productCategorie">Kies een productcategorie</label>
            <select id="productCategorie" name="productCategorie" onchange="showSubFields()" required>
                <option value="">--- Selecteer een categorie ---</option>
                <option value="Beeldscherm">Beeldscherm</option>
                <option value="Laptop">Laptop</option>
                <option value="DockingStation">DockingStation (€160)</option>
                <option value="Arbo">Arbo-middelen (muis, toetsenbord, etc.)</option>
                <option value="Smartphone">Smartphones & Tablets</option>
                <option value="Printers">Printers & Scanners</option>
                <option value="Overig">Overige hardware/software</option>
            </select>
        </div>

        <!-- Dynamic sub-fields will appear here -->
        <div id="sub-fields-container"></div>

        <div class="form-group">
            <label for="motivatie">Motivatie voor deze aanvraag</label>
            <textarea id="motivatie" name="motivatie" rows="6" required></textarea>
        </div>

        <button type="submit" class="btn">Dien Aanvraag In</button>
    </form>
</div>

<script>
function showSubFields() {
    var category = document.getElementById('productCategorie').value;
    var container = document.getElementById('sub-fields-container');
    var html = '';

    switch (category) {
        case 'Beeldscherm':
            html = `
                <div class="form-group">
                    <label for="productType">Kies het formaat</label>
                    <select name="productType" class="form-control" required>
                        <option value="Standaard 22-24 inch">Standaard 22-24"</option>
                        <option value="Groot 27 inch">Groot 27"</option>
                        <option value="Zeer groot 32 inch">Zeer groot 32"</option>
                    </select>
                    <small>Prijsindicatie: Standaard (€150), Groot (€250), Zeer groot (€400)</small>
                </div>`;
            break;
        case 'Laptop':
            html = `
                <div class="form-group">
                    <label for="productType">Kies het type laptop</label>
                    <select name="productType" class="form-control" required>
                        <option value="Laptop Scrubber">Laptop Scrubber (€1.600)</option>
                        <option value="Semi-Ruggedized Laptop">Semi-Ruggedized Laptop (€2.215)</option>
                    </select>
                </div>`;
            break;
        case 'Arbo':
            html = `
                <div class="form-group">
                    <label for="productType">Kies uw arbo-middel</label>
                    <select name="productType" class="form-control" required>
                        <option value="Ergonomische muis">Ergonomische muis</option>
                        <option value="Compact toetsenbord">Compact toetsenbord</option>
                        <option value="Tekentablet">Tekentablet</option>
                        <option value="Laptopstandaard">Laptopstandaard</option>
                    </select>
                </div>`;
            break;
        case 'Smartphone':
             html = `
                <div class="form-group">
                    <label for="productType">Kies uw apparaat</label>
                    <select name="productType" class="form-control" required>
                        <option value="Standaard Smartphone">Standaard Smartphone</option>
                        <option value="Ruggedized Smartphone">Ruggedized Smartphone</option>
                        <option value="Tablet">Tablet</option>
                        <option value="Ruggedized Tablet">Ruggedized Tablet</option>
                        <option value="Accessoires">Accessoires (bv. hoesje, lader)</option>
                    </select>
                </div>`;
            break;
        case 'Printers':
             html = `
                <div class="form-group">
                    <label for="productType">Kies uw apparaat</label>
                    <select name="productType" class="form-control" required>
                        <option value="Barcodeprinter">Barcodeprinter</option>
                        <option value="Barcodescanner">Barcodescanner</option>
                        <option value="Werkplekscanner">Werkplekscanner</option>
                        <option value="Labelprinter">Labelprinter</option>
                    </select>
                </div>`;
            break;
        case 'DockingStation':
        case 'Overig':
            // No specific fields, the motivation is key here.
            // For 'Overig', we might add a text field.
             html = `
                <div class="form-group">
                    <label for="productType">Omschrijf de benodigde hardware/software</label>
                    <input type="text" name="productType" class="form-control" required value="${category === 'DockingStation' ? 'DockingStation' : ''}">
                </div>`;
            break;
    }
    container.innerHTML = html;
}

// Initialize the fields on page load in case of a refresh
document.addEventListener('DOMContentLoaded', function() {
    showSubFields();
});
</script>

<!-- #include file="common/footer.asp" -->
