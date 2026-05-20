using {
    managed,
    cuid,
    Currency,
    Country,
    sap.common.CodeList
} from '@sap/cds/common';

namespace my.bookshop;

type NoOfBooks : Integer;

type Price {
    amount   : Decimal(10, 2);
    currency : Currency default 'USD'; // Automatic value help avaialble at UI
}

type Genre     : Integer enum {
    fiction = 1;
    non_fiction = 2;
}

@cds.localized : false
@cds.autoexpose: true
entity Authors : cuid, managed { //implicitaspects { // Aspects from @sap/cds/common
    name        : String(255);
    dateOfBirth : Date;
    dateOfDeath : Date;
    epoch       : Association to Epochs @assert.target; // nothing with value help
    // resposne - epoch_ID
    //managed to-one associations of a CDS model entit
    books       : Association to many Books // Automatic value help NOT avaialble at UI
                      on books.author = $self;
// books will not come in respose due to many association, but we can navigate to books via $links
}

// //1. without aspects,
// extend Authors with {
//     someadditionalField : String(100); // This also adds this field to the generated database table.
// //name : String(300); //the length of an existing element of type String can be increased.
// }

// //2. with explicit aspects,
// extend Authors with explicitaspects;

// aspect explicitaspects {
//     someadditionalField2 : String(100);
// }

// //3. with implicit aspects
// aspect implicitaspects {
//     someadditionalField3 : String(100);
// }
//4. Standard Aspects
//   managed, cuid,

@isRoot
@odata.containment: false
@cds.localized    : false
entity Books : cuid, managed {
    @Core.Immutable: true //field cannot be updated after creation
    bookid      : String(20)              @title: 'Book ID'; //bookid     @Core.Immutable: true,   // ← enforce here in service layer
    author      : Association to Authors  @mandatory                                  @assert.target;
    //author_id is generated in response as flattened structure of author, rule is author association name + _ID
    title       : String(100)             @title: 'Book Name' @mandatory; // localized that require translated texts
    //<your_service_url>/Books?sap-locale=de
    genre       : Genre                   @title: 'Genre'                             @assert.range: true;
    //assert.range - Value 3 is invalid according to enum declaration {1, 2}
    //ordinal types - i.e. numeric or date/time types.
    publCountry : Country                 @title: 'Publishing Country'  default 'US'  @assert.target; //Automatic value help avaialble at UI
    // publCountry_code is generated in response as flattened structure of publCountry
    price       : Price                   @title: 'Price'                             @assert.target;
    // price_amount, price_currency_code are generated in the response as flattened structure of price
    stock       : NoOfBooks               @title: 'Stock';
    isHardcover : Boolean                 @title: 'Hardcover' default true;
}

@cds.localized: false
entity Epochs : CodeList {
    key ID : Integer;
}
