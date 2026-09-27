// Demo dataset for CampusSwap — the single source of truth for the seed data.
//
// Used by:
//   scripts/generate_auth_import.mjs  (creates the verified Auth accounts)
//   scripts/seed_demo_data.mjs        (writes the Firestore documents)
//
// Everything here is deliberately fake: the accounts live on the reserved
// `.test` TLD (RFC 2606 — never resolvable, so no real inbox can be reached)
// and every uid is prefixed `seed` so the dataset is easy to find and clear.

import {
  BULK_USERS,
  BULK_LISTINGS,
  BULK_LISTING_STATUS,
  BULK_THREADS,
  BULK_SWAPS,
  BULK_REPORTS,
  BULK_NOTIFICATIONS,
  BULK_EXTRA_FAVORITES,
} from './bulk_data.mjs';

/** Shared password for every demo account. Credentials never touch Firestore. */
export const DEMO_PASSWORD = 'DemoStudent2026';

const BASE_USERS = [
  {
    uid: 'seedAmina',
    email: 'amina.wanjiru@campusswap.test',
    displayName: 'Amina Wanjiru',
    university: 'University of Nairobi',
    campus: 'Main Campus',
    photoUrl: 'https://i.pravatar.cc/150?u=seedAmina',
    bio: 'Education student. I sell my textbooks at the end of every semester.',
    rating: 4.8,
    ratingCount: 32,
  },
  {
    uid: 'seedBrian',
    email: 'brian.otieno@campusswap.test',
    displayName: 'Brian Otieno',
    university: 'JKUAT',
    campus: 'Juja Campus',
    photoUrl: 'https://i.pravatar.cc/150?u=seedBrian',
    bio: 'Laptops and gadgets. All tested before I list them.',
    rating: 4.6,
    ratingCount: 18,
  },
  {
    uid: 'seedCynthia',
    email: 'cynthia.mwangi@campusswap.test',
    displayName: 'Cynthia Mwangi',
    university: 'Strathmore University',
    campus: 'Madaraka Campus',
    photoUrl: 'https://i.pravatar.cc/150?u=seedCynthia',
    bio: 'Clearing out my bedsitter. Everything must go before I graduate.',
    rating: 4.9,
    ratingCount: 41,
  },
  {
    uid: 'seedDavid',
    email: 'david.kimani@campusswap.test',
    displayName: 'David Kimani',
    university: 'Kenyatta University',
    campus: 'Thika Road',
    photoUrl: 'https://i.pravatar.cc/150?u=seedDavid',
    bio: 'Mostly here to buy. Selling a couple of things I no longer use.',
    rating: 4.2,
    ratingCount: 7,
  },
  {
    uid: 'seedEsther',
    email: 'esther.achieng@campusswap.test',
    displayName: 'Esther Achieng',
    university: 'Moi University',
    campus: 'Eldoret Main',
    photoUrl: 'https://i.pravatar.cc/150?u=seedEsther',
    bio: 'Thrift and kitenge. Fair prices, quick to reply.',
    rating: 4.7,
    ratingCount: 22,
  },
  {
    uid: 'seedFelix',
    email: 'felix.mutua@campusswap.test',
    displayName: 'Felix Mutua',
    university: 'Egerton University',
    campus: 'Njoro Campus',
    photoUrl: 'https://i.pravatar.cc/150?u=seedFelix',
    bio: 'Engineering student. Drawing sets, stationery and lab gear.',
    rating: 4.4,
    ratingCount: 12,
  },
  {
    uid: 'seedGrace',
    email: 'grace.njeri@campusswap.test',
    displayName: 'Grace Njeri',
    university: 'USIU-Africa',
    campus: 'Kasarani',
    photoUrl: 'https://i.pravatar.cc/150?u=seedGrace',
    bio: 'International relations. I sell whatever I outgrow.',
    rating: 4.85,
    ratingCount: 27,
  },
  {
    uid: 'seedHassan',
    email: 'hassan.abdi@campusswap.test',
    displayName: 'Hassan Abdi',
    university: 'University of Nairobi',
    campus: 'Main Campus',
    photoUrl: 'https://i.pravatar.cc/150?u=seedHassan',
    bio: 'Always up for a swap. Ask me about electronics.',
    rating: 4.5,
    ratingCount: 15,
  },
  {
    // Deliberately brand new: no listings, no history, so the empty states in
    // the app have something to be empty *with*.
    uid: 'seedIrene',
    email: 'irene.chebet@campusswap.test',
    displayName: 'Irene Chebet',
    university: 'Daystar University',
    campus: 'Athi River',
    photoUrl: null,
    bio: null,
    rating: 0,
    ratingCount: 0,
  },
  {
    uid: 'seedJoseph',
    email: 'joseph.mwenda@campusswap.test',
    displayName: 'Joseph Mwenda',
    university: 'JKUAT',
    campus: 'Juja Campus',
    photoUrl: 'https://i.pravatar.cc/150?u=seedJoseph',
    bio: 'Sports gear and the odd gadget. Negotiable on everything.',
    rating: 4.3,
    ratingCount: 9,
  },
];

/**
 * `img` is how many placeholder photos to attach (0–3). The rules cap a
 * listing at 6; 0 exercises the "no photo" placeholder in the UI.
 * `views`, `status` and `favorites` are applied after creation, through the
 * same write paths the app uses.
 */
const BASE_LISTINGS = [
  // --- Amina: textbooks ----------------------------------------------------
  { key: 'calculus', seller: 'seedAmina', title: 'Calculus: Early Transcendentals, 8th Edition',
    desc: 'James Stewart. Clean copy, no missing pages. A few pencil notes in chapters 1-4 that I can erase on request.',
    price: 2500, category: 'textbooks', condition: 'likeNew', type: 'sale', author: 'James Stewart', courseCode: 'MAT 101', isbn: '978-1285741550', img: 2, views: 214, favorites: ['seedDavid', 'seedFelix', 'seedIrene'] },
  { key: 'clrs', seller: 'seedAmina', title: 'Introduction to Algorithms (CLRS), 3rd Edition',
    desc: 'The big one. Spine intact, cover slightly worn at the corners. Perfect for CS 201 and interview prep.',
    price: 3200, category: 'textbooks', condition: 'good', type: 'sale', author: 'Cormen, Leiserson, Rivest, Stein', courseCode: 'CS 201', isbn: '978-0262033848', img: 1, views: 178, favorites: ['seedHassan', 'seedBrian'] },
  { key: 'biology', seller: 'seedAmina', title: 'Campbell Biology, 11th Edition',
    desc: 'Some highlighting in the genetics section, otherwise in solid shape. Comes with a free lab notebook.',
    price: 2800, category: 'textbooks', condition: 'fair', type: 'sale', author: 'Lisa Urry', courseCode: 'BIO 102', isbn: '978-0134093413', img: 1, views: 96, favorites: [] },
  { key: 'physics', seller: 'seedAmina', title: 'Fundamentals of Physics — Halliday & Resnick',
    desc: 'Extended 10th edition. Good condition, binding tight. I used it for two semesters of PHY 101.',
    price: 2200, category: 'textbooks', condition: 'good', type: 'sale', author: 'Halliday, Resnick, Walker', courseCode: 'PHY 101', img: 2, views: 143, favorites: ['seedFelix'] },
  { key: 'organicchem', seller: 'seedAmina', title: 'Organic Chemistry — Clayden, 2nd Edition',
    desc: 'Barely used, I switched majors. No writing inside at all. Still has the original bookmark.',
    price: 3000, category: 'textbooks', condition: 'likeNew', type: 'sale', author: 'Clayden, Greeves, Warren', courseCode: 'CHE 201', isbn: '978-0199270293', img: 1, views: 71, favorites: [] },
  { key: 'economics', seller: 'seedAmina', title: 'Principles of Economics — Mankiw',
    desc: 'Would happily swap for a statistics textbook. Otherwise selling cheap, it is only gathering dust here.',
    price: 1800, category: 'textbooks', condition: 'good', type: 'swap', author: 'N. Gregory Mankiw', courseCode: 'ECO 101', img: 1, views: 88, favorites: ['seedDavid'] },
  { key: 'accounting', seller: 'seedAmina', title: 'Financial Accounting — IFRS Edition',
    desc: 'Second edition. Cover has a small tear at the bottom but every page is intact and readable.',
    price: 2400, category: 'textbooks', condition: 'good', type: 'sale', author: 'Weygandt, Kimmel, Kieso', courseCode: 'BAC 102', img: 0, views: 54, favorites: [] },
  { key: 'dictionary', seller: 'seedAmina', title: "Oxford Advanced Learner's Dictionary, 10th Edition",
    desc: 'Hardcover, no CD. Great condition. Ideal if you write a lot of essays and hate typing everything.',
    price: 1200, category: 'textbooks', condition: 'good', type: 'sale', img: 1, views: 39, favorites: [] },

  // --- Brian: electronics --------------------------------------------------
  { key: 'elitebook', seller: 'seedBrian', title: 'HP EliteBook 840 G5 — i5, 8GB RAM, 256GB SSD',
    desc: 'Ex-UK unit, battery holds about 5 hours. Fresh Windows 11 install. Charger included. No dents, screen flawless.',
    price: 32000, category: 'electronics', condition: 'good', type: 'sale', img: 3, views: 412, favorites: ['seedDavid', 'seedIrene', 'seedJoseph', 'seedGrace'] },
  { key: 'latitude', seller: 'seedBrian', title: 'Dell Latitude 7490 — i7, 16GB RAM, 512GB SSD',
    desc: 'My daily driver for two years. Backlit keyboard, fingerprint reader works. Selling because I upgraded.',
    price: 45000, category: 'electronics', condition: 'likeNew', type: 'sale', img: 2, views: 287, favorites: ['seedHassan'] },
  { key: 'casio', seller: 'seedBrian', title: 'Casio fx-991EX Classwiz Scientific Calculator',
    desc: 'The one allowed in most exams. Fully working, slide cover included. Batteries are fresh.',
    price: 1500, category: 'electronics', condition: 'likeNew', type: 'sale', img: 1, views: 331, favorites: ['seedFelix', 'seedIrene', 'seedDavid', 'seedGrace', 'seedJoseph'] },
  { key: 'ti84', seller: 'seedBrian', title: 'Texas Instruments TI-84 Plus Graphing Calculator',
    desc: 'Imported. Works perfectly, comes with the USB cable. Rarely seen on campus so grab it while it is here.',
    price: 6500, category: 'electronics', condition: 'good', type: 'sale', img: 1, views: 124, favorites: ['seedFelix'] },
  { key: 'sony', seller: 'seedBrian', title: 'Sony WH-1000XM3 Noise Cancelling Headphones',
    desc: 'Noise cancelling still excellent. Earpads replaced last month. Carry case and cable included.',
    price: 12000, category: 'electronics', condition: 'good', type: 'sale', img: 2, views: 198, favorites: ['seedEsther'] },
  { key: 'powerbank', seller: 'seedBrian', title: 'Anker PowerCore 20000mAh Power Bank',
    desc: 'Charges a phone about four times over. Bought it for field work, barely used since. No scratches.',
    price: 2800, category: 'electronics', condition: 'likeNew', type: 'sale', img: 1, views: 87, favorites: ['seedJoseph'] },
  { key: 'arduino', seller: 'seedBrian', title: 'Arduino Uno R3 Starter Kit (Complete)',
    desc: 'Every component still in the box: breadboard, jumper wires, sensors, servos. Happy to swap for a monitor.',
    price: 3500, category: 'electronics', condition: 'likeNew', type: 'swap', img: 2, views: 156, favorites: ['seedHassan'] },
  { key: 'monitor', seller: 'seedBrian', title: 'Samsung 24-inch LED Monitor (HDMI + VGA)',
    desc: '1080p, no dead pixels. Ideal second screen for coding. Stand and both cables included.',
    price: 11000, category: 'electronics', condition: 'good', type: 'sale', img: 1, views: 143, favorites: ['seedHassan', 'seedDavid'] },

  // --- Cynthia: dorm & home ------------------------------------------------
  { key: 'fridge', seller: 'seedCynthia', title: 'Hisense Mini Fridge 90L — Perfect for Bedsitter',
    desc: 'Keeps drinks properly cold, freezer box works. Moving out at the end of the month so it must go.',
    price: 12000, category: 'dorm', condition: 'good', type: 'sale', img: 2, views: 264, favorites: ['seedFelix', 'seedIrene'] },
  { key: 'kettle', seller: 'seedCynthia', title: 'Russell Hobbs Electric Kettle 1.7L',
    desc: 'Boils fast, auto shut-off works. Descaled last week. Small scuff on the base that you cannot see.',
    price: 1800, category: 'dorm', condition: 'likeNew', type: 'sale', img: 1, views: 112, favorites: [] },
  { key: 'mattress', seller: 'seedCynthia', title: 'Single Bed Mattress 4 inch (3x6)',
    desc: 'Used one semester with a mattress protector on the whole time. No stains, no sagging. Comes with the cover.',
    price: 7000, category: 'dorm', condition: 'good', type: 'sale', img: 1, views: 176, favorites: ['seedJoseph'] },
  { key: 'desk', seller: 'seedCynthia', title: 'Study Desk with Three Drawers',
    desc: 'Sturdy wooden desk, fits a laptop plus two textbooks comfortably. You will need a way to carry it.',
    price: 6500, category: 'dorm', condition: 'good', type: 'sale', img: 2, views: 131, favorites: [] },
  { key: 'lamp', seller: 'seedCynthia', title: 'LED Reading Lamp — Adjustable, Three Brightness Levels',
    desc: 'Clips onto a bed frame or desk. USB powered so it works even during blackouts with a power bank.',
    price: 900, category: 'dorm', condition: 'likeNew', type: 'sale', img: 1, views: 78, favorites: ['seedIrene'] },
  { key: 'pots', seller: 'seedCynthia', title: 'Cooking Pot Set — 5 Pieces, Non-stick',
    desc: 'All five sizes, lids included. Handles are firm. Ideal first set for someone moving into their own place.',
    price: 3200, category: 'dorm', condition: 'good', type: 'sale', img: 1, views: 94, favorites: [] },
  { key: 'iron', seller: 'seedCynthia', title: 'Philips Steam Iron',
    desc: 'Works well, no leaks. Soleplate has minor marks from use but glides fine. Cable is full length.',
    price: 1600, category: 'dorm', condition: 'good', type: 'sale', img: 0, views: 61, favorites: [] },
  { key: 'dispenser', seller: 'seedCynthia', title: 'Hot & Cold Water Dispenser',
    desc: 'Takes the standard 20L bottle. Both elements work. Selling because my new place has a filter tap.',
    price: 8500, category: 'dorm', condition: 'good', type: 'swap', img: 1, views: 118, favorites: ['seedFelix'] },

  // --- Esther: clothing ----------------------------------------------------
  { key: 'hoodie', seller: 'seedEsther', title: 'Official University Hoodie — Size L',
    desc: 'Navy, embroidered crest. Worn a handful of times. No fading, no pilling, drawstrings intact.',
    price: 1800, category: 'clothing', condition: 'good', type: 'sale', img: 2, views: 167, favorites: ['seedGrace'] },
  { key: 'gown', seller: 'seedEsther', title: 'Graduation Gown and Cap — Complete Set',
    desc: 'Worn once for my own graduation. Includes gown, cap, tassel and hood. Dry cleaned and bagged.',
    price: 4500, category: 'clothing', condition: 'likeNew', type: 'sale', img: 2, views: 289, favorites: ['seedJoseph', 'seedGrace', 'seedDavid'] },
  { key: 'af1', seller: 'seedEsther', title: 'Nike Air Force 1 — Size 42, White',
    desc: 'Genuine pair, slight creasing on the toe box as expected. Soles still white. Comes with the box.',
    price: 6500, category: 'clothing', condition: 'good', type: 'sale', img: 3, views: 203, favorites: ['seedJoseph'] },
  { key: 'labcoat', seller: 'seedEsther', title: 'Lab Coat — Brand New, Size M',
    desc: 'Bought two by mistake, this one is still sealed in its packaging. Required for all lab sessions.',
    price: 1200, category: 'clothing', condition: 'newItem', type: 'sale', img: 1, views: 88, favorites: ['seedFelix', 'seedIrene'] },
  { key: 'backpack', seller: 'seedEsther', title: 'Leather Laptop Backpack — Fits 15.6 inch',
    desc: 'Padded laptop sleeve, water resistant. Used for one semester, all zips run smoothly.',
    price: 2800, category: 'clothing', condition: 'good', type: 'sale', img: 1, views: 121, favorites: [] },
  { key: 'suit', seller: 'seedEsther', title: 'Navy Suit — Size 40R, for Attachments and Interviews',
    desc: 'Tailored fit, worn twice for interviews. Jacket and trousers, no shine on the elbows or knees.',
    price: 7500, category: 'clothing', condition: 'likeNew', type: 'sale', img: 2, views: 149, favorites: ['seedGrace'] },

  // --- Felix: supplies -----------------------------------------------------
  { key: 'drawingboard', seller: 'seedFelix', title: 'A2 Drawing Board with T-Square Set',
    desc: 'Essential for engineering drawing. Board is flat with no warping, T-square edge is true.',
    price: 2500, category: 'supplies', condition: 'good', type: 'sale', img: 1, views: 132, favorites: ['seedHassan'] },
  { key: 'drawingset', seller: 'seedFelix', title: 'Engineering Drawing Set — Complete in Case',
    desc: 'Compass, dividers, set squares, protractor, scale rule. All pieces present and in the original case.',
    price: 1800, category: 'supplies', condition: 'likeNew', type: 'sale', img: 1, views: 97, favorites: [] },
  { key: 'paper', seller: 'seedFelix', title: 'A4 Paper — Box of 5 Reams (2500 Sheets)',
    desc: '80gsm, sealed boxes. Cheaper than the campus shop. Buy the whole box or ask about single reams.',
    price: 2000, category: 'supplies', condition: 'newItem', type: 'sale', img: 0, views: 156, favorites: ['seedDavid'] },
  { key: 'labbooks', seller: 'seedFelix', title: 'Lab Report Books — Pack of 3',
    desc: 'Ruled and graph pages, 100 pages each. Unused. Sold as a pack of three, no splitting please.',
    price: 450, category: 'supplies', condition: 'newItem', type: 'sale', img: 1, views: 64, favorites: [] },
  { key: 'markers', seller: 'seedFelix', title: 'Highlighters and Whiteboard Marker Set',
    desc: 'Six highlighters and four whiteboard markers, all sealed. Great for revision timetables.',
    price: 650, category: 'supplies', condition: 'newItem', type: 'sale', img: 1, views: 43, favorites: [] },
  { key: 'artsupplies', seller: 'seedFelix', title: 'Art Supplies Bundle — Acrylics, Brushes, Canvas',
    desc: 'Left over from a design unit. Twelve paints, a brush set and two small canvases. Swap for stationery.',
    price: 3000, category: 'supplies', condition: 'good', type: 'swap', img: 2, views: 77, favorites: ['seedGrace'] },

  // --- Grace: mixed --------------------------------------------------------
  { key: 'ipad', seller: 'seedGrace', title: 'iPad 9th Generation 64GB with Apple Pencil',
    desc: 'Space grey, WiFi only. Battery health still great. Screen protector on since day one, no scratches.',
    price: 38000, category: 'electronics', condition: 'likeNew', type: 'sale', img: 2, views: 356, favorites: ['seedBrian', 'seedDavid', 'seedIrene'] },
  { key: 'camera', seller: 'seedGrace', title: 'Canon EOS 1300D DSLR with 18-55mm Lens',
    desc: 'Shutter count under 8000. Comes with bag, charger and a 32GB card. Great for a media student.',
    price: 28000, category: 'electronics', condition: 'good', type: 'sale', img: 3, views: 241, favorites: ['seedJoseph'] },
  { key: 'guitar', seller: 'seedGrace', title: 'Acoustic Guitar with Bag and Capo',
    desc: 'Sweet tone, stays in tune. Fresh strings put on last week. Would swap for a decent keyboard.',
    price: 8500, category: 'other', condition: 'good', type: 'swap', img: 2, views: 188, favorites: ['seedHassan', 'seedEsther'] },
  { key: 'chess', seller: 'seedGrace', title: 'Wooden Tournament Chess Set',
    desc: 'Weighted pieces, folding board. Board has a small scratch on one edge, pieces are all complete.',
    price: 1500, category: 'other', condition: 'good', type: 'sale', img: 1, views: 72, favorites: [] },
  { key: 'speaker', seller: 'seedGrace', title: 'JBL Flip 5 Bluetooth Speaker',
    desc: 'Loud for its size, waterproof. Charging port is clean and the battery still lasts all day.',
    price: 5500, category: 'electronics', condition: 'good', type: 'sale', img: 1, views: 164, favorites: ['seedJoseph', 'seedDavid'] },
  { key: 'curtains', seller: 'seedGrace', title: 'Bedsitter Curtains — Two Pairs, with Rails',
    desc: 'Navy and grey, both pairs with the hanging rails. Washed and ready. Fits a standard single window.',
    price: 1500, category: 'dorm', condition: 'good', type: 'sale', img: 1, views: 51, favorites: [] },

  // --- Hassan: electronics + swaps ----------------------------------------
  { key: 'redmi', seller: 'seedHassan', title: 'Xiaomi Redmi Note 11 — 128GB, 6GB RAM',
    desc: 'Dual SIM, fingerprint works, no cracks. Comes with a case and a tempered glass already fitted.',
    price: 15000, category: 'electronics', condition: 'good', type: 'sale', img: 2, views: 227, favorites: ['seedJoseph', 'seedBrian'] },
  { key: 'mouse', seller: 'seedHassan', title: 'Logitech MX Master 2S Wireless Mouse',
    desc: 'The good one with the thumb wheel. Charges by USB-C, battery lasts weeks. Smooth on any surface.',
    price: 4500, category: 'electronics', condition: 'good', type: 'sale', img: 1, views: 118, favorites: ['seedBrian'] },
  { key: 'echo', seller: 'seedHassan', title: 'Amazon Echo Dot (3rd Gen) Smart Speaker',
    desc: 'Works fine on campus WiFi once set up. Selling because I mostly use headphones now.',
    price: 3500, category: 'electronics', condition: 'good', type: 'swap', img: 1, views: 83, favorites: [] },

  // --- Joseph: sports + other ---------------------------------------------
  { key: 'bike', seller: 'seedJoseph', title: 'Mountain Bike — 26 inch, 21 Speed',
    desc: 'Solid commuter. Gears index cleanly, brakes just serviced, tyres have plenty of tread left.',
    price: 15000, category: 'other', condition: 'good', type: 'sale', img: 2, views: 218, favorites: ['seedHassan', 'seedDavid'] },
  { key: 'yogamat', seller: 'seedJoseph', title: 'Yoga Mat and Resistance Band Set',
    desc: 'Mat is 6mm and non-slip, wiped down after every session. Bands are light, medium and heavy.',
    price: 1800, category: 'other', condition: 'likeNew', type: 'sale', img: 1, views: 69, favorites: ['seedIrene'] },
  { key: 'football', seller: 'seedJoseph', title: 'Nike Football — Size 5',
    desc: 'Giving this away free to anyone who will actually use it. Slightly scuffed but holds air perfectly.',
    price: 0, category: 'other', condition: 'good', type: 'free', img: 1, views: 131, favorites: ['seedEsther', 'seedFelix'] },
  { key: 'jersey', seller: 'seedJoseph', title: 'Football Jersey — Size L, Home Kit',
    desc: 'Bought the wrong size and never wore it. Tags removed but it has never been on a pitch.',
    price: 1200, category: 'clothing', condition: 'newItem', type: 'sale', img: 1, views: 58, favorites: [] },
  { key: 'ps4game', seller: 'seedJoseph', title: 'FIFA 24 — PS4 Disc',
    desc: 'Case and disc both in great shape, no scratches on the disc. Finished the season, moving on.',
    price: 3500, category: 'other', condition: 'likeNew', type: 'sale', img: 1, views: 143, favorites: ['seedDavid'] },

  // --- David: the occasional seller ---------------------------------------
  { key: 'calcbook', seller: 'seedDavid', title: 'Business Statistics Textbook — Custom Edition',
    desc: 'The edition the lecturer actually sets questions from. Light highlighting in the first two chapters.',
    price: 1600, category: 'textbooks', condition: 'good', type: 'sale', courseCode: 'STA 101', img: 1, views: 47, favorites: [] },
  { key: 'headphones', seller: 'seedDavid', title: 'JBL Tune 510BT Wireless Headphones',
    desc: 'On-ear, folds flat, battery lasts about 40 hours. Earpads are clean, no flaking.',
    price: 3200, category: 'electronics', condition: 'good', type: 'sale', img: 1, views: 92, favorites: [] },

  // --- a listing already promised to someone (status applied below) --------
  { key: 'desklamp2', seller: 'seedCynthia', title: 'Adjustable Desk Lamp with Wireless Charging Base',
    desc: 'Charging pad works with any phone that supports wireless charging. Three colour temperatures.',
    price: 2200, category: 'dorm', condition: 'likeNew', type: 'sale', img: 1, views: 105, favorites: ['seedGrace'] },
  { key: 'notebook', seller: 'seedFelix', title: 'Hardcover Journal — A5, Dotted, Unused',
    desc: 'Bought two, only need one. Dotted pages, lies flat, elastic closure and ribbon bookmark.',
    price: 700, category: 'supplies', condition: 'newItem', type: 'sale', img: 1, views: 36, favorites: [] },
];

/** Statuses to apply after creation (the app writes these as owner updates). */
const BASE_LISTING_STATUS = {
  desklamp2: 'reserved',
  notebook: 'sold',
};

/**
 * Chat threads. `messages` alternate freely; `from` is 'buyer' or 'seller'
 * relative to the conversation. `image: true` sends a photo with no caption,
 * matching how the app sends a picture-only message.
 */
const BASE_THREADS = [
  {
    key: 'calculus-david',
    listing: 'calculus',
    buyer: 'seedDavid',
    messages: [
      { from: 'buyer', text: 'Hi Amina, is the Stewart calculus book still available?' },
      { from: 'seller', text: 'Hi David, yes it is still available.' },
      { from: 'buyer', text: 'Great. Would you take 2000 for it?' },
      { from: 'seller', text: 'I can do 2300. The pencil notes wipe off, I promise.' },
      { from: 'buyer', text: 'Deal. Can we meet at the library entrance tomorrow at 10?' },
      { from: 'seller', text: 'Works for me. I will bring it in a paper bag so it does not get rained on.' },
      { from: 'buyer', text: 'Perfect, see you then.' },
    ],
  },
  {
    key: 'elitebook-irene',
    listing: 'elitebook',
    buyer: 'seedIrene',
    messages: [
      { from: 'buyer', text: 'Hello Brian, I am interested in the EliteBook. Is the price negotiable?' },
      { from: 'seller', text: 'Hi Irene. Slightly, yes. It comes with the original charger.' },
      { from: 'buyer', text: 'Can you confirm the battery really lasts 5 hours? I need it for long library sessions.' },
      { from: 'seller', text: 'On light use (browsing, notes) I get about 5 hours. Video drains it faster, maybe 3.' },
      { from: 'buyer', text: 'That is fine. Does it have a backlit keyboard?' },
      { from: 'seller', text: 'The 840 G5 does, yes. Here is a photo of it powered on.' },
      { from: 'seller', image: true },
      { from: 'buyer', text: 'Looks good. Would you accept 30000?' },
      { from: 'seller', text: 'I can meet you at 31000 and I will throw in a laptop sleeve.' },
      { from: 'buyer', text: 'Let me think about it tonight and get back to you.' },
    ],
  },
  {
    key: 'fridge-felix',
    listing: 'fridge',
    buyer: 'seedFelix',
    messages: [
      { from: 'buyer', text: 'Hi Cynthia, does the fridge fit under a standard desk?' },
      { from: 'seller', text: 'It is 84cm tall so it fits beside a desk, not under it.' },
      { from: 'buyer', text: 'Good to know. Is the freezer box removable?' },
      { from: 'seller', text: 'It is, yes. I will send a photo of the inside later today.' },
    ],
  },
  {
    key: 'arduino-hassan',
    listing: 'arduino',
    buyer: 'seedHassan',
    messages: [
      { from: 'buyer', text: 'Brian, would you swap the Arduino kit for my Echo Dot?' },
      { from: 'seller', text: 'Possibly. Does the Echo work on the hostel WiFi? Ours needs a login page.' },
      { from: 'buyer', text: 'It needs a phone hotspot for the setup, then it works fine after that.' },
      { from: 'seller', text: 'That is a bit of a hassle for me honestly.' },
      { from: 'buyer', text: 'Fair enough. I could add 1000 on top if that helps.' },
      { from: 'seller', text: 'Let me think about it and let you know by Friday.' },
    ],
  },
  {
    key: 'gown-joseph',
    listing: 'gown',
    buyer: 'seedJoseph',
    messages: [
      { from: 'buyer', text: 'Hi Esther, is the graduation gown still available? My sister graduates next month.' },
      { from: 'seller', text: 'It is! It was dry cleaned after my ceremony and it is bagged up.' },
      { from: 'buyer', text: 'Does it come with the hood for a bachelor degree?' },
      { from: 'seller', text: 'Yes, gown, cap, tassel and the hood are all included.' },
      { from: 'buyer', text: 'Can I come and see it this weekend before deciding?' },
      { from: 'seller', text: 'Of course. Saturday afternoon is best for me.' },
    ],
  },
  {
    key: 'bike-joseph-david',
    listing: 'bike',
    buyer: 'seedDavid',
    messages: [
      { from: 'buyer', text: 'Joseph, is the bike still up? I need something for the commute from Thika Road.' },
      { from: 'seller', text: 'Still available. It handles that route well, I used it daily.' },
      { from: 'buyer', text: 'Any issues with the gears?' },
      { from: 'seller', text: 'None, they index cleanly. I just had the brakes serviced too.' },
      { from: 'buyer', text: 'Would you take 13000?' },
      { from: 'seller', text: '13500 and I will include the pump and the lock.' },
      { from: 'buyer', text: 'Sold. When can I pick it up?' },
    ],
  },
  {
    key: 'ipad-grace-david',
    listing: 'ipad',
    buyer: 'seedDavid',
    messages: [
      { from: 'buyer', text: 'Hi Grace, does the iPad come with the original charger?' },
      { from: 'seller', text: 'It comes with a charger and cable, though not the original box.' },
      { from: 'buyer', text: 'That is fine. Has it ever been repaired?' },
      { from: 'seller', text: 'Never. It has had a screen protector and a case since the first day.' },
      { from: 'buyer', text: 'I will take it if you can hold it until Friday when my HELB comes through.' },
      { from: 'seller', text: 'I can hold it until Friday, but please confirm by then.' },
    ],
  },
  {
    key: 'casio-grace',
    listing: 'casio',
    buyer: 'seedGrace',
    messages: [
      { from: 'buyer', text: 'Is the Classwiz still available? I need one before the exams start.' },
      { from: 'seller', text: 'Yes, I have it with me on campus today.' },
      { from: 'buyer', text: 'Can I pick it up at the cafeteria in an hour?' },
      { from: 'seller', text: 'Sure, text me when you are outside.' },
      { from: 'buyer', text: 'On my way now.' },
    ],
  },
  {
    key: 'guitar-hassan',
    listing: 'guitar',
    buyer: 'seedHassan',
    messages: [
      { from: 'buyer', text: 'Hi Grace, would you consider swapping the guitar for an Arduino starter kit?' },
      { from: 'seller', text: 'That is tempting. Is the kit complete with all the sensors?' },
      { from: 'buyer', text: 'Complete, everything is still in the box.' },
      { from: 'seller', text: 'Send me a photo of the contents and I will decide.' },
      { from: 'buyer', image: true },
      { from: 'seller', text: 'Okay that looks well kept. Let me sleep on it.' },
    ],
  },
  {
    key: 'hoodie-grace',
    listing: 'hoodie',
    buyer: 'seedGrace',
    messages: [
      { from: 'buyer', text: 'Does the hoodie shrink after washing? Asking before I commit.' },
      { from: 'seller', text: 'I washed it cold and it did not shrink at all.' },
      { from: 'buyer', text: 'Great, I will take it. Can we meet at the gate?' },
      { from: 'seller', text: 'Sure, I am around tomorrow morning.' },
    ],
  },
  {
    key: 'redmi-joseph',
    listing: 'redmi',
    buyer: 'seedJoseph',
    messages: [
      { from: 'buyer', text: 'Hassan, does the Redmi have any issues with the charging port?' },
      { from: 'seller', text: 'None at all, it charges fast and the cable sits firm.' },
      { from: 'buyer', text: 'And the screen has no cracks?' },
      { from: 'seller', text: 'No cracks, the tempered glass has been on it since new.' },
      { from: 'buyer', text: 'Let me check my budget and revert.' },
    ],
  },
  {
    key: 'camera-grace-joseph',
    listing: 'camera',
    buyer: 'seedJoseph',
    messages: [
      { from: 'buyer', text: 'Is the 1300D good for shooting campus events at night?' },
      { from: 'seller', text: 'With the kit lens it struggles indoors, but a cheap 50mm f1.8 fixes that.' },
      { from: 'buyer', text: 'Good advice. Does the price include the memory card?' },
      { from: 'seller', text: 'Yes, the 32GB card and the bag are both included.' },
    ],
  },
  {
    key: 'mattress-irene',
    listing: 'mattress',
    buyer: 'seedIrene',
    messages: [
      { from: 'buyer', text: 'Hi Cynthia, is the mattress firm or soft? I have a bad back.' },
      { from: 'seller', text: 'It is medium firm, quite supportive. I slept well on it.' },
      { from: 'buyer', text: 'Do you have a photo of the actual mattress?' },
      { from: 'seller', image: true },
      { from: 'buyer', text: 'Looks clean. I will confirm tomorrow after I measure my room.' },
    ],
  },
  {
    key: 'sony-esther',
    listing: 'sony',
    buyer: 'seedEsther',
    messages: [
      { from: 'buyer', text: 'How is the noise cancelling in a matatu? That is my main use.' },
      { from: 'seller', text: 'Honestly excellent, it kills the engine drone almost completely.' },
      { from: 'buyer', text: 'That is exactly what I need. Can I test them first?' },
      { from: 'seller', text: 'Sure, bring your phone and pair them when we meet.' },
    ],
  },
];

/**
 * Swap proposals and how they end. 'accepted' also flips the listing to
 * `swapped`, mirroring FirestoreRepository.respondToSwap.
 */
const BASE_SWAPS = [
  { key: 'swap-economics', listing: 'economics', offerer: 'seedDavid', offered: 'calcbook', outcome: 'pending',
    message: 'Would you swap for my Business Statistics textbook? Same value roughly.' },
  { key: 'swap-arduino-kit', listing: 'arduino', offerer: 'seedHassan', offered: 'echo', outcome: 'pending',
    message: 'My Echo Dot plus 1000 in cash for the Arduino kit?' },
  { key: 'swap-guitar-keys', listing: 'guitar', offerer: 'seedHassan', offered: 'arduino', outcome: 'pending',
    message: 'Arduino starter kit for the guitar? Complete and barely used.' },
  { key: 'swap-dispenser', listing: 'dispenser', offerer: 'seedFelix', offered: 'artsupplies', outcome: 'pending',
    message: 'Art supplies bundle for the dispenser, if you still need one.' },
  { key: 'swap-drawingboard', listing: 'drawingboard', offerer: 'seedHassan', offered: 'mouse', outcome: 'accepted',
    message: 'MX Master 2S for the drawing board? You said you needed a mouse.' },
  { key: 'swap-artsupplies', listing: 'artsupplies', offerer: 'seedGrace', offered: 'chess', outcome: 'accepted',
    message: 'Chess set for the art supplies? I am trying to learn to paint.' },
  { key: 'swap-echo-dot', listing: 'echo', offerer: 'seedGrace', offered: 'chess', outcome: 'declined',
    message: 'Wooden chess set for the Echo?' },
  { key: 'swap-football', listing: 'football', offerer: 'seedFelix', offered: 'notebook', outcome: 'declined',
    message: 'I will swap the journal for the ball if you want one.' },
  { key: 'swap-pots', listing: 'pots', offerer: 'seedJoseph', offered: 'yogamat', outcome: 'cancelled',
    message: 'Yoga mat set for the pots? I am moving into a bedsitter.' },
  { key: 'swap-backpack', listing: 'backpack', offerer: 'seedDavid', offered: 'headphones', outcome: 'cancelled',
    message: 'JBL Tune headphones for the backpack?' },
];

/** Listings other users have saved. Each also bumps the listing's counter. */
const BASE_EXTRA_FAVORITES = [
  ['seedAmina', 'clrs'],
  ['seedAmina', 'ipad'],
  ['seedBrian', 'calculus'],
  ['seedCynthia', 'fridge'],
  ['seedEsther', 'gown'],
  ['seedGrace', 'sony'],
  ['seedHassan', 'latitude'],
  ['seedIrene', 'casio'],
  ['seedIrene', 'fridge'],
  ['seedJoseph', 'bike'],
  ['seedDavid', 'elitebook'],
  ['seedFelix', 'powerbank'],
];

/** Reports are write-only from the client; moderators read them in the console. */
const BASE_REPORTS = [
  { key: 'report-01', reporter: 'seedDavid', listing: 'echo', reason: 'Wrong category',
    details: 'This is listed under electronics but it is really a home device.' },
  { key: 'report-02', reporter: 'seedGrace', listing: 'ps4game', reason: 'Suspected counterfeit',
    details: 'The case artwork looks like a reprint. Worth checking with the seller.' },
  { key: 'report-03', reporter: 'seedHassan', listing: 'jersey', reason: 'Prohibited item',
    details: 'Unbranded replica kit presented as official merchandise.' },
  { key: 'report-04', reporter: 'seedIrene', listing: 'redmi', reason: 'Misleading photos',
    details: 'The photos look like stock images rather than the actual phone.' },
];

/**
 * Standalone notifications (chat and swap notifications are generated
 * automatically as those threads and proposals are seeded).
 */
const BASE_EXTRA_NOTIFICATIONS = [
  { key: 'notif-welcome', user: 'seedIrene', title: 'Welcome to CampusSwap',
    body: 'Browse listings from your campus and save the ones you like.', type: 'system', read: true },
  { key: 'notif-sold', user: 'seedFelix', title: 'Listing sold',
    body: '"Hardcover Journal — A5, Dotted, Unused" was marked as sold.', type: 'listingSold', read: false },
  { key: 'notif-swapped', user: 'seedHassan', title: 'Listing swapped',
    body: '"A2 Drawing Board with T-Square Set" was marked as swapped.', type: 'listingSwapped', read: false },
  { key: 'notif-tip', user: 'seedDavid', title: 'Tip: verify before you pay',
    body: 'Meet on campus in daylight and inspect the item before sending money.', type: 'system', read: true },
];

// --- merged dataset (curated base + bulk expansion) ------------------------
// The seeder and the auth-import generator import these merged arrays. The base
// literals above stay hand-authored; bulk_data.mjs only ever appends, so the
// seedIrene empty-state invariant (never a seller) and every base key survive.
// Favourite pairs that appear in both halves are deduplicated by the seeder.
export const DEMO_USERS = [...BASE_USERS, ...BULK_USERS];
export const LISTINGS = [...BASE_LISTINGS, ...BULK_LISTINGS];
export const LISTING_STATUS = { ...BASE_LISTING_STATUS, ...BULK_LISTING_STATUS };
export const THREADS = [...BASE_THREADS, ...BULK_THREADS];
export const SWAPS = [...BASE_SWAPS, ...BULK_SWAPS];
export const EXTRA_FAVORITES = [...BASE_EXTRA_FAVORITES, ...BULK_EXTRA_FAVORITES];
export const REPORTS = [...BASE_REPORTS, ...BULK_REPORTS];
export const EXTRA_NOTIFICATIONS = [...BASE_EXTRA_NOTIFICATIONS, ...BULK_NOTIFICATIONS];
