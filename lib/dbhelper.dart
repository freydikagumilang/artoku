import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = new DBHelper.internal();

  DBHelper.internal();
  factory DBHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await setDb();
    return _db;
  }

  setDb() async {
    var dir = await getDatabasesPath();
    String dbpath = join(dir, "artokubeta");
    var dB = await openDatabase(dbpath, version: 1, onCreate: _initDB,onUpgrade: _migrate);
    return dB;
  }
  void _initDB(Database db, int ver) async {
    print("created init_db");
    String sSQL =
        '''Create table IF NOT EXISTS invoice (inv_id INTEGER PRIMARY KEY autoincrement,inv_no string,inv_plg_id int,
                  inv_date string, inv_total_bruto real, inv_diskon real,inv_total_net real,
                  inv_paid real,inv_iscash integer,inv_created_at integer,inv_updated_at integer DEFAULT 0 ,inv_deleted_at integer DEFAULT 0  )''';

    await db.execute(sSQL);
    String sSQLdet = '''Create table IF NOT EXISTS invoicedet (
      invdet_id INTEGER PRIMARY KEY autoincrement,
      invdet_inv_id int,invdet_item_id int,
      invdet_ket string, invdet_qty real, invdet_price real,invdet_total real,
      invdet_komisi real,invdet_kapster_id integer,invdet_created_at integer,invdet_updated_at integer DEFAULT 0 ,
      invdet_deleted_at integer DEFAULT 0  )''';

    await db.execute(sSQLdet);
    await db.rawQuery("Create table IF NOT EXISTS kapster (kapster_id INTEGER PRIMARY KEY autoincrement,kapster_nama string,kapster_hp string,kapster_alamat string)");
    
    await db.rawQuery("Create table IF NOT EXISTS pelanggan (pelanggan_id INTEGER PRIMARY KEY autoincrement,pelanggan_nama string,pelanggan_hp string,pelanggan_alamat string)");

    sSQL =
        '''Create table IF NOT EXISTS bukukas (bukukas_id INTEGER PRIMARY KEY autoincrement,
                  bukukas_tunai real,bukukas_non_tunai double,
                  bukukas_created_at integer,bukukas_updated_at integer DEFAULT 0 ,bukukas_deleted_at integer DEFAULT 0  )''';

    await db.rawQuery(sSQL);

    sSQLdet =
        '''Create table IF NOT EXISTS bukukasdet (bukukasdet_id INTEGER PRIMARY KEY autoincrement,
                  bukukasdet_tunai real,bukukasdet_non_tunai double,bukukasdet_ket string,
                  bukukasdet_created_at integer,bukukasdet_updated_at integer DEFAULT 0 ,bukukasdet_deleted_at integer DEFAULT 0  )''';

    await db.rawQuery(sSQLdet);

    sSQL = '''Create table IF NOT EXISTS produk 
    (prod_id INTEGER PRIMARY KEY autoincrement,
    prod_barcode TEXT,
    prod_nama TEXT,
    prod_kat_id INTEGER,
    prod_img TEXT,
    prod_countable INTEGER,
    prod_stock REAL,
    prod_price REAL,
    prod_cogs REAL,
    prod_suspended INTEGER,
    prod_sale_retention INTEGER
    )''';
    await db.rawQuery(sSQL);

  }
  void _migrate(Database db, int oldVersion, int newVersion) async {
    // const initScript = ['Create table migrations (version INTEGER)','insert into migrations(0)']; // Initialization script split into seperate statements
    // initScript.forEach((script) async => await db.execute(script));
    // print("migrate");
    // const migrationScripts = [
    //   //'String query',
    // ];
    // int ver = 0;
    // List<Map> _migration = await db.rawQuery("select * from migrations");
    // for (var i = 0; i < _migration.length; i++) {
    //   ver = _migration[i]['version'];
    // }
    
    // for (var x=ver; x < migrationScripts.length; x++) {
    //    db.execute(migrationScripts[x]);
    //    print(migrationScripts[x]);
    //    ver++;
    // }
    // db.execute("update migrations set version = ${ver}");    
  }

  
}