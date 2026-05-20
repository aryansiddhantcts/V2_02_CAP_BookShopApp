using {
    managed,
    cuid,
    sap.common.CodeList
} from '@sap/cds/common';

namespace my.bookshop;

type NoOfBooks : Integer;

type Price {
    amount   : Decimal(10, 2);
    currency : String(3);
}

type Genre     : Integer enum {
    fiction = 1;
    non_fiction = 2;
}

// entity Authors : cuid, managed {
//     name        : String(255);
//     dateOfBirth : Date;
//     dateOfDeath : Date;
// }
@isRoot
@odata.containment: false cds
entity Books : cuid, managed {
    @Core.Immutable: true                            //field cannot be updated after creation
    bookid      : String(20)  @title: 'Book ID';     //bookid     @Core.Immutable: true,   // ← enforce here in service layer
    title       : String(100) @title: 'Book Name';
    genre       : Genre       @title: 'Genre';
    publCountry : String(3)   @title: 'Publishing Country';
    price       : Price       @title: 'Price';
    stock       : NoOfBooks   @title: 'Stock';
    isHardcover : Boolean     @title: 'Hardcover' default true;
}
