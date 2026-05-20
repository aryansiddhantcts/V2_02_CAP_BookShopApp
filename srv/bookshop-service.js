
const cds = require('@sap/cds');
 
module.exports = class BookShopService extends cds.ApplicationService {
 
  async init() {
 
    const { Books } = this.entities;
 
    // ═══════════════════════════════════════════════════════════════════════
    // BEFORE handlers — run BEFORE the DB operation
    // Use for: validation, auto-fill, reject requests
    // ═══════════════════════════════════════════════════════════════════════
 
    // ── CREATE: Auto-generate bookid + validate required fields ────────────
    this.before('CREATE', Books, (req) => {
      const book = req.data;
 
      // Auto-generate bookid if not provided
      if (!book.bookid) {
        book.bookid = 'BK-' + Date.now();
      }
 
      // Validate required fields
      if (!book.title)       req.error(400, 'Title is required.');
      if (!book.publCountry) req.error(400, 'Publishing Country is required.');
 
      // Validate stock is not negative
      if (book.stock !== undefined && book.stock < 0) {
        req.error(400, 'Stock cannot be negative.');
      }
 
      // Validate price amount
      if (book.price_amount !== undefined && book.price_amount < 0) {
        req.error(400, 'Price amount cannot be negative.');
      }
 
      console.log(`[BEFORE CREATE] Book: ${book.title} | ID: ${book.bookid}`);
    });
 
    // ── READ: Log who is reading ───────────────────────────────────────────
    this.before('READ', Books, (req) => {
      console.log(`[BEFORE READ] Query: ${JSON.stringify(req.query)}`);
    });
 
    // ── UPDATE: Validate fields on edit ────────────────────────────────────
    this.before('UPDATE', Books, (req) => {
      const { bookid, title, stock, price_amount } = req.data;
      
      // Prevent clearing title on update
      if (title !== undefined && !title) {
        req.error(400, 'Title cannot be empty.');
      }
 
      // Validate stock on update
      if (stock !== undefined && stock < 0) {
        req.error(400, 'Stock cannot be negative.');
      }
 
      // Validate price on update
      if (price_amount !== undefined && price_amount < 0) {
        req.error(400, 'Price amount cannot be negative.');
      }
      // Book ID validation
      if (bookid !== undefined && !bookid) {
        req.error(400, 'Book ID cannot be empty.');
      }

      console.log(`[BEFORE UPDATE] Updating book ID: ${req.data.ID}`);
    });
 
    // ── DELETE: Prevent deleting books with stock ──────────────────────────
    this.before('DELETE', Books, async (req) => {
      const book = await SELECT.one.from(Books).where({ ID: req.data.ID });
 
      if (book && book.stock > 0) {
        req.error(400, `Cannot delete "${book.title}" — it still has ${book.stock} units in stock.`);
      }
 
      console.log(`[BEFORE DELETE] Deleting book ID: ${req.data.ID}`);
    });
 
    // ═══════════════════════════════════════════════════════════════════════
    // ON handlers — REPLACES the default DB operation
    // Use for: custom logic, calling external APIs, overriding default behavior
    // Always call next() to proceed with default behavior
    // ═══════════════════════════════════════════════════════════════════════
 
    // ── CREATE: Custom create with external API call (example) ─────────────
    this.on('CREATE', Books, async (req, next) => {
      console.log(`[ON CREATE] Creating book: ${req.data.title}`);
 
      // Example: call external API before saving
      // await callExternalAPI(req.data);
 
      // Proceed with default CAP CREATE
      return next();
    });
 
    // ── READ: Custom read with additional filtering (example) ──────────────
    this.on('READ', Books, async (req, next) => {
      console.log(`[ON READ] Reading books`);
 
      // Proceed with default CAP READ
      const result = await next();
 
      // Example: enrich response with computed fields
      // if (Array.isArray(result)) {
      //   result.forEach(book => book.priceFormatted = `${book.price_currency} ${book.price_amount}`);
      // }
 
      return result;
    });
 
    // ── UPDATE: Custom update with audit trail (example) ───────────────────
    this.on('UPDATE', Books, async (req, next) => {
      console.log(`[ON UPDATE] Updating book ID: ${req.data.ID}`);
 
      // Example: log changes to audit table
      // await INSERT.into('AuditLog').entries({ entityId: req.data.ID, changedAt: new Date() });
 
      // Proceed with default CAP UPDATE
      return next();
    });
 
    // ── DELETE: Custom delete with cascading (example) ─────────────────────
    this.on('DELETE', Books, async (req, next) => {
      console.log(`[ON DELETE] Deleting book ID: ${req.data.ID}`);
 
      // Example: notify external system before deletion
      // await notifyExternalSystem(req.data.ID);
 
      // Proceed with default CAP DELETE
      return next();
    });
 
    // ═══════════════════════════════════════════════════════════════════════
    // AFTER handlers — run AFTER the DB operation
    // Use for: post-processing, notifications, logging, enriching response
    // ═══════════════════════════════════════════════════════════════════════
 
    // ── CREATE: Log successful creation ────────────────────────────────────
    this.after('CREATE', Books, (book, req) => {
      console.log(`[AFTER CREATE] Book created: ${book.title} | bookid: ${book.bookid} | UUID: ${book.ID}`);
 
      // Example: send notification
      // sendEmail(`New book added: ${book.title}`);
    });
 
    // ── READ: Enrich response with computed fields ─────────────────────────
    this.after('READ', Books, (books) => {
      // books can be array (list) or single object (detail)
      const list = Array.isArray(books) ? books : [books];
 
      list.forEach(book => {
        if (book) {
          // Add a computed display field
          book.priceFormatted = book.price_amount && book.price_currency_code
            ? `${book.price_currency_code} ${book.price_amount}`
            : 'N/A';
 
          // Add genre label
          book.genreLabel = book.genre === 1 ? 'Fiction' : 'Non Fiction';
        }
      });
 
      console.log(`[AFTER READ] Returned ${list.length} book(s)`);
    });
 
    // ── UPDATE: Log successful update ──────────────────────────────────────
    this.after('UPDATE', Books, (book, req) => {
      console.log(`[AFTER UPDATE] Book updated: ID: ${req.data.ID}`);
 
      // Example: sync to external system after update
      // syncToExternalSystem(req.data);
    });
 
    // ── DELETE: Log successful deletion ────────────────────────────────────
    this.after('DELETE', Books, (_, req) => {
      console.log(`[AFTER DELETE] Book deleted: ID: ${req.data.ID}`);
 
      // Example: remove from search index
      // removeFromSearchIndex(req.data.ID);
    });
 
    return super.init();
  }
};