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
@odata.containment: false 
entity Books : cuid, managed {
    @Core.Immutable: true
    bookid      : String(20)  @title: 'Book ID';
    title       : String(100) @title: 'Book Name';
    genre       : Genre       @title: 'Genre';
    publCountry : String(3)   @title: 'Publishing Country';
    price       : Price       @title: 'Price';
    stock       : NoOfBooks   @title: 'Stock';
    isHardcover : Boolean     @title: 'Hardcover';
}
