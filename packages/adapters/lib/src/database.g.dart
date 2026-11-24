// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $StoresTable extends Stores with TableInfo<$StoresTable, StoreRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rutMeta = const VerificationMeta('rut');
  @override
  late final GeneratedColumn<String> rut = GeneratedColumn<String>(
    'rut',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _legalNameMeta = const VerificationMeta(
    'legalName',
  );
  @override
  late final GeneratedColumn<String> legalName = GeneratedColumn<String>(
    'legal_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _businessLineMeta = const VerificationMeta(
    'businessLine',
  );
  @override
  late final GeneratedColumn<String> businessLine = GeneratedColumn<String>(
    'business_line',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taxConfigMeta = const VerificationMeta(
    'taxConfig',
  );
  @override
  late final GeneratedColumn<String> taxConfig = GeneratedColumn<String>(
    'tax_config',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    rut,
    legalName,
    businessLine,
    taxConfig,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stores';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoreRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('rut')) {
      context.handle(
        _rutMeta,
        rut.isAcceptableOrUnknown(data['rut']!, _rutMeta),
      );
    } else if (isInserting) {
      context.missing(_rutMeta);
    }
    if (data.containsKey('legal_name')) {
      context.handle(
        _legalNameMeta,
        legalName.isAcceptableOrUnknown(data['legal_name']!, _legalNameMeta),
      );
    } else if (isInserting) {
      context.missing(_legalNameMeta);
    }
    if (data.containsKey('business_line')) {
      context.handle(
        _businessLineMeta,
        businessLine.isAcceptableOrUnknown(
          data['business_line']!,
          _businessLineMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_businessLineMeta);
    }
    if (data.containsKey('tax_config')) {
      context.handle(
        _taxConfigMeta,
        taxConfig.isAcceptableOrUnknown(data['tax_config']!, _taxConfigMeta),
      );
    } else if (isInserting) {
      context.missing(_taxConfigMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoreRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoreRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      rut: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rut'],
      )!,
      legalName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}legal_name'],
      )!,
      businessLine: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_line'],
      )!,
      taxConfig: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tax_config'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StoresTable createAlias(String alias) {
    return $StoresTable(attachedDatabase, alias);
  }
}

class StoreRow extends DataClass implements Insertable<StoreRow> {
  final String id;
  final String rut;
  final String legalName;
  final String businessLine;
  final String taxConfig;
  final String createdAt;
  const StoreRow({
    required this.id,
    required this.rut,
    required this.legalName,
    required this.businessLine,
    required this.taxConfig,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['rut'] = Variable<String>(rut);
    map['legal_name'] = Variable<String>(legalName);
    map['business_line'] = Variable<String>(businessLine);
    map['tax_config'] = Variable<String>(taxConfig);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  StoresCompanion toCompanion(bool nullToAbsent) {
    return StoresCompanion(
      id: Value(id),
      rut: Value(rut),
      legalName: Value(legalName),
      businessLine: Value(businessLine),
      taxConfig: Value(taxConfig),
      createdAt: Value(createdAt),
    );
  }

  factory StoreRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoreRow(
      id: serializer.fromJson<String>(json['id']),
      rut: serializer.fromJson<String>(json['rut']),
      legalName: serializer.fromJson<String>(json['legalName']),
      businessLine: serializer.fromJson<String>(json['businessLine']),
      taxConfig: serializer.fromJson<String>(json['taxConfig']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'rut': serializer.toJson<String>(rut),
      'legalName': serializer.toJson<String>(legalName),
      'businessLine': serializer.toJson<String>(businessLine),
      'taxConfig': serializer.toJson<String>(taxConfig),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  StoreRow copyWith({
    String? id,
    String? rut,
    String? legalName,
    String? businessLine,
    String? taxConfig,
    String? createdAt,
  }) => StoreRow(
    id: id ?? this.id,
    rut: rut ?? this.rut,
    legalName: legalName ?? this.legalName,
    businessLine: businessLine ?? this.businessLine,
    taxConfig: taxConfig ?? this.taxConfig,
    createdAt: createdAt ?? this.createdAt,
  );
  StoreRow copyWithCompanion(StoresCompanion data) {
    return StoreRow(
      id: data.id.present ? data.id.value : this.id,
      rut: data.rut.present ? data.rut.value : this.rut,
      legalName: data.legalName.present ? data.legalName.value : this.legalName,
      businessLine: data.businessLine.present
          ? data.businessLine.value
          : this.businessLine,
      taxConfig: data.taxConfig.present ? data.taxConfig.value : this.taxConfig,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoreRow(')
          ..write('id: $id, ')
          ..write('rut: $rut, ')
          ..write('legalName: $legalName, ')
          ..write('businessLine: $businessLine, ')
          ..write('taxConfig: $taxConfig, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, rut, legalName, businessLine, taxConfig, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoreRow &&
          other.id == this.id &&
          other.rut == this.rut &&
          other.legalName == this.legalName &&
          other.businessLine == this.businessLine &&
          other.taxConfig == this.taxConfig &&
          other.createdAt == this.createdAt);
}

class StoresCompanion extends UpdateCompanion<StoreRow> {
  final Value<String> id;
  final Value<String> rut;
  final Value<String> legalName;
  final Value<String> businessLine;
  final Value<String> taxConfig;
  final Value<String> createdAt;
  final Value<int> rowid;
  const StoresCompanion({
    this.id = const Value.absent(),
    this.rut = const Value.absent(),
    this.legalName = const Value.absent(),
    this.businessLine = const Value.absent(),
    this.taxConfig = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoresCompanion.insert({
    required String id,
    required String rut,
    required String legalName,
    required String businessLine,
    required String taxConfig,
    required String createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       rut = Value(rut),
       legalName = Value(legalName),
       businessLine = Value(businessLine),
       taxConfig = Value(taxConfig),
       createdAt = Value(createdAt);
  static Insertable<StoreRow> custom({
    Expression<String>? id,
    Expression<String>? rut,
    Expression<String>? legalName,
    Expression<String>? businessLine,
    Expression<String>? taxConfig,
    Expression<String>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rut != null) 'rut': rut,
      if (legalName != null) 'legal_name': legalName,
      if (businessLine != null) 'business_line': businessLine,
      if (taxConfig != null) 'tax_config': taxConfig,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoresCompanion copyWith({
    Value<String>? id,
    Value<String>? rut,
    Value<String>? legalName,
    Value<String>? businessLine,
    Value<String>? taxConfig,
    Value<String>? createdAt,
    Value<int>? rowid,
  }) {
    return StoresCompanion(
      id: id ?? this.id,
      rut: rut ?? this.rut,
      legalName: legalName ?? this.legalName,
      businessLine: businessLine ?? this.businessLine,
      taxConfig: taxConfig ?? this.taxConfig,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (rut.present) {
      map['rut'] = Variable<String>(rut.value);
    }
    if (legalName.present) {
      map['legal_name'] = Variable<String>(legalName.value);
    }
    if (businessLine.present) {
      map['business_line'] = Variable<String>(businessLine.value);
    }
    if (taxConfig.present) {
      map['tax_config'] = Variable<String>(taxConfig.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoresCompanion(')
          ..write('id: $id, ')
          ..write('rut: $rut, ')
          ..write('legalName: $legalName, ')
          ..write('businessLine: $businessLine, ')
          ..write('taxConfig: $taxConfig, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductsTable extends Products
    with TableInfo<$ProductsTable, ProductRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _salePriceClpMeta = const VerificationMeta(
    'salePriceClp',
  );
  @override
  late final GeneratedColumn<int> salePriceClp = GeneratedColumn<int>(
    'sale_price_clp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costClpMeta = const VerificationMeta(
    'costClp',
  );
  @override
  late final GeneratedColumn<int> costClp = GeneratedColumn<int>(
    'cost_clp',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _barcodeMeta = const VerificationMeta(
    'barcode',
  );
  @override
  late final GeneratedColumn<String> barcode = GeneratedColumn<String>(
    'barcode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _qrPayloadMeta = const VerificationMeta(
    'qrPayload',
  );
  @override
  late final GeneratedColumn<String> qrPayload = GeneratedColumn<String>(
    'qr_payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<int> stock = GeneratedColumn<int>(
    'stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _blockWhenOutOfStockMeta =
      const VerificationMeta('blockWhenOutOfStock');
  @override
  late final GeneratedColumn<bool> blockWhenOutOfStock = GeneratedColumn<bool>(
    'block_when_out_of_stock',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("block_when_out_of_stock" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    name,
    salePriceClp,
    costClp,
    barcode,
    qrPayload,
    stock,
    blockWhenOutOfStock,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sale_price_clp')) {
      context.handle(
        _salePriceClpMeta,
        salePriceClp.isAcceptableOrUnknown(
          data['sale_price_clp']!,
          _salePriceClpMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_salePriceClpMeta);
    }
    if (data.containsKey('cost_clp')) {
      context.handle(
        _costClpMeta,
        costClp.isAcceptableOrUnknown(data['cost_clp']!, _costClpMeta),
      );
    }
    if (data.containsKey('barcode')) {
      context.handle(
        _barcodeMeta,
        barcode.isAcceptableOrUnknown(data['barcode']!, _barcodeMeta),
      );
    }
    if (data.containsKey('qr_payload')) {
      context.handle(
        _qrPayloadMeta,
        qrPayload.isAcceptableOrUnknown(data['qr_payload']!, _qrPayloadMeta),
      );
    }
    if (data.containsKey('stock')) {
      context.handle(
        _stockMeta,
        stock.isAcceptableOrUnknown(data['stock']!, _stockMeta),
      );
    } else if (isInserting) {
      context.missing(_stockMeta);
    }
    if (data.containsKey('block_when_out_of_stock')) {
      context.handle(
        _blockWhenOutOfStockMeta,
        blockWhenOutOfStock.isAcceptableOrUnknown(
          data['block_when_out_of_stock']!,
          _blockWhenOutOfStockMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_blockWhenOutOfStockMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      salePriceClp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sale_price_clp'],
      )!,
      costClp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_clp'],
      ),
      barcode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}barcode'],
      ),
      qrPayload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}qr_payload'],
      ),
      stock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock'],
      )!,
      blockWhenOutOfStock: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}block_when_out_of_stock'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class ProductRow extends DataClass implements Insertable<ProductRow> {
  final String id;
  final String storeId;
  final String name;
  final int salePriceClp;
  final int? costClp;
  final String? barcode;
  final String? qrPayload;
  final int stock;
  final bool blockWhenOutOfStock;
  const ProductRow({
    required this.id,
    required this.storeId,
    required this.name,
    required this.salePriceClp,
    this.costClp,
    this.barcode,
    this.qrPayload,
    required this.stock,
    required this.blockWhenOutOfStock,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['name'] = Variable<String>(name);
    map['sale_price_clp'] = Variable<int>(salePriceClp);
    if (!nullToAbsent || costClp != null) {
      map['cost_clp'] = Variable<int>(costClp);
    }
    if (!nullToAbsent || barcode != null) {
      map['barcode'] = Variable<String>(barcode);
    }
    if (!nullToAbsent || qrPayload != null) {
      map['qr_payload'] = Variable<String>(qrPayload);
    }
    map['stock'] = Variable<int>(stock);
    map['block_when_out_of_stock'] = Variable<bool>(blockWhenOutOfStock);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      storeId: Value(storeId),
      name: Value(name),
      salePriceClp: Value(salePriceClp),
      costClp: costClp == null && nullToAbsent
          ? const Value.absent()
          : Value(costClp),
      barcode: barcode == null && nullToAbsent
          ? const Value.absent()
          : Value(barcode),
      qrPayload: qrPayload == null && nullToAbsent
          ? const Value.absent()
          : Value(qrPayload),
      stock: Value(stock),
      blockWhenOutOfStock: Value(blockWhenOutOfStock),
    );
  }

  factory ProductRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductRow(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      name: serializer.fromJson<String>(json['name']),
      salePriceClp: serializer.fromJson<int>(json['salePriceClp']),
      costClp: serializer.fromJson<int?>(json['costClp']),
      barcode: serializer.fromJson<String?>(json['barcode']),
      qrPayload: serializer.fromJson<String?>(json['qrPayload']),
      stock: serializer.fromJson<int>(json['stock']),
      blockWhenOutOfStock: serializer.fromJson<bool>(
        json['blockWhenOutOfStock'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'name': serializer.toJson<String>(name),
      'salePriceClp': serializer.toJson<int>(salePriceClp),
      'costClp': serializer.toJson<int?>(costClp),
      'barcode': serializer.toJson<String?>(barcode),
      'qrPayload': serializer.toJson<String?>(qrPayload),
      'stock': serializer.toJson<int>(stock),
      'blockWhenOutOfStock': serializer.toJson<bool>(blockWhenOutOfStock),
    };
  }

  ProductRow copyWith({
    String? id,
    String? storeId,
    String? name,
    int? salePriceClp,
    Value<int?> costClp = const Value.absent(),
    Value<String?> barcode = const Value.absent(),
    Value<String?> qrPayload = const Value.absent(),
    int? stock,
    bool? blockWhenOutOfStock,
  }) => ProductRow(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    name: name ?? this.name,
    salePriceClp: salePriceClp ?? this.salePriceClp,
    costClp: costClp.present ? costClp.value : this.costClp,
    barcode: barcode.present ? barcode.value : this.barcode,
    qrPayload: qrPayload.present ? qrPayload.value : this.qrPayload,
    stock: stock ?? this.stock,
    blockWhenOutOfStock: blockWhenOutOfStock ?? this.blockWhenOutOfStock,
  );
  ProductRow copyWithCompanion(ProductsCompanion data) {
    return ProductRow(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      name: data.name.present ? data.name.value : this.name,
      salePriceClp: data.salePriceClp.present
          ? data.salePriceClp.value
          : this.salePriceClp,
      costClp: data.costClp.present ? data.costClp.value : this.costClp,
      barcode: data.barcode.present ? data.barcode.value : this.barcode,
      qrPayload: data.qrPayload.present ? data.qrPayload.value : this.qrPayload,
      stock: data.stock.present ? data.stock.value : this.stock,
      blockWhenOutOfStock: data.blockWhenOutOfStock.present
          ? data.blockWhenOutOfStock.value
          : this.blockWhenOutOfStock,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductRow(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('name: $name, ')
          ..write('salePriceClp: $salePriceClp, ')
          ..write('costClp: $costClp, ')
          ..write('barcode: $barcode, ')
          ..write('qrPayload: $qrPayload, ')
          ..write('stock: $stock, ')
          ..write('blockWhenOutOfStock: $blockWhenOutOfStock')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    name,
    salePriceClp,
    costClp,
    barcode,
    qrPayload,
    stock,
    blockWhenOutOfStock,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductRow &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.name == this.name &&
          other.salePriceClp == this.salePriceClp &&
          other.costClp == this.costClp &&
          other.barcode == this.barcode &&
          other.qrPayload == this.qrPayload &&
          other.stock == this.stock &&
          other.blockWhenOutOfStock == this.blockWhenOutOfStock);
}

class ProductsCompanion extends UpdateCompanion<ProductRow> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<String> name;
  final Value<int> salePriceClp;
  final Value<int?> costClp;
  final Value<String?> barcode;
  final Value<String?> qrPayload;
  final Value<int> stock;
  final Value<bool> blockWhenOutOfStock;
  final Value<int> rowid;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.name = const Value.absent(),
    this.salePriceClp = const Value.absent(),
    this.costClp = const Value.absent(),
    this.barcode = const Value.absent(),
    this.qrPayload = const Value.absent(),
    this.stock = const Value.absent(),
    this.blockWhenOutOfStock = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductsCompanion.insert({
    required String id,
    required String storeId,
    required String name,
    required int salePriceClp,
    this.costClp = const Value.absent(),
    this.barcode = const Value.absent(),
    this.qrPayload = const Value.absent(),
    required int stock,
    required bool blockWhenOutOfStock,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       name = Value(name),
       salePriceClp = Value(salePriceClp),
       stock = Value(stock),
       blockWhenOutOfStock = Value(blockWhenOutOfStock);
  static Insertable<ProductRow> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<String>? name,
    Expression<int>? salePriceClp,
    Expression<int>? costClp,
    Expression<String>? barcode,
    Expression<String>? qrPayload,
    Expression<int>? stock,
    Expression<bool>? blockWhenOutOfStock,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (name != null) 'name': name,
      if (salePriceClp != null) 'sale_price_clp': salePriceClp,
      if (costClp != null) 'cost_clp': costClp,
      if (barcode != null) 'barcode': barcode,
      if (qrPayload != null) 'qr_payload': qrPayload,
      if (stock != null) 'stock': stock,
      if (blockWhenOutOfStock != null)
        'block_when_out_of_stock': blockWhenOutOfStock,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductsCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<String>? name,
    Value<int>? salePriceClp,
    Value<int?>? costClp,
    Value<String?>? barcode,
    Value<String?>? qrPayload,
    Value<int>? stock,
    Value<bool>? blockWhenOutOfStock,
    Value<int>? rowid,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      name: name ?? this.name,
      salePriceClp: salePriceClp ?? this.salePriceClp,
      costClp: costClp ?? this.costClp,
      barcode: barcode ?? this.barcode,
      qrPayload: qrPayload ?? this.qrPayload,
      stock: stock ?? this.stock,
      blockWhenOutOfStock: blockWhenOutOfStock ?? this.blockWhenOutOfStock,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (salePriceClp.present) {
      map['sale_price_clp'] = Variable<int>(salePriceClp.value);
    }
    if (costClp.present) {
      map['cost_clp'] = Variable<int>(costClp.value);
    }
    if (barcode.present) {
      map['barcode'] = Variable<String>(barcode.value);
    }
    if (qrPayload.present) {
      map['qr_payload'] = Variable<String>(qrPayload.value);
    }
    if (stock.present) {
      map['stock'] = Variable<int>(stock.value);
    }
    if (blockWhenOutOfStock.present) {
      map['block_when_out_of_stock'] = Variable<bool>(
        blockWhenOutOfStock.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('name: $name, ')
          ..write('salePriceClp: $salePriceClp, ')
          ..write('costClp: $costClp, ')
          ..write('barcode: $barcode, ')
          ..write('qrPayload: $qrPayload, ')
          ..write('stock: $stock, ')
          ..write('blockWhenOutOfStock: $blockWhenOutOfStock, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StockMovementsTable extends StockMovements
    with TableInfo<$StockMovementsTable, StockMovementRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StockMovementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deltaMeta = const VerificationMeta('delta');
  @override
  late final GeneratedColumn<int> delta = GeneratedColumn<int>(
    'delta',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actorIdMeta = const VerificationMeta(
    'actorId',
  );
  @override
  late final GeneratedColumn<String> actorId = GeneratedColumn<String>(
    'actor_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    productId,
    delta,
    reason,
    note,
    actorId,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stock_movements';
  @override
  VerificationContext validateIntegrity(
    Insertable<StockMovementRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('delta')) {
      context.handle(
        _deltaMeta,
        delta.isAcceptableOrUnknown(data['delta']!, _deltaMeta),
      );
    } else if (isInserting) {
      context.missing(_deltaMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('actor_id')) {
      context.handle(
        _actorIdMeta,
        actorId.isAcceptableOrUnknown(data['actor_id']!, _actorIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StockMovementRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StockMovementRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      delta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}delta'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      actorId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StockMovementsTable createAlias(String alias) {
    return $StockMovementsTable(attachedDatabase, alias);
  }
}

class StockMovementRow extends DataClass
    implements Insertable<StockMovementRow> {
  final String id;
  final String storeId;
  final String productId;
  final int delta;
  final String reason;
  final String? note;
  final String? actorId;
  final String createdAt;
  const StockMovementRow({
    required this.id,
    required this.storeId,
    required this.productId,
    required this.delta,
    required this.reason,
    this.note,
    this.actorId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['product_id'] = Variable<String>(productId);
    map['delta'] = Variable<int>(delta);
    map['reason'] = Variable<String>(reason);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    if (!nullToAbsent || actorId != null) {
      map['actor_id'] = Variable<String>(actorId);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  StockMovementsCompanion toCompanion(bool nullToAbsent) {
    return StockMovementsCompanion(
      id: Value(id),
      storeId: Value(storeId),
      productId: Value(productId),
      delta: Value(delta),
      reason: Value(reason),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      actorId: actorId == null && nullToAbsent
          ? const Value.absent()
          : Value(actorId),
      createdAt: Value(createdAt),
    );
  }

  factory StockMovementRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StockMovementRow(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      productId: serializer.fromJson<String>(json['productId']),
      delta: serializer.fromJson<int>(json['delta']),
      reason: serializer.fromJson<String>(json['reason']),
      note: serializer.fromJson<String?>(json['note']),
      actorId: serializer.fromJson<String?>(json['actorId']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'productId': serializer.toJson<String>(productId),
      'delta': serializer.toJson<int>(delta),
      'reason': serializer.toJson<String>(reason),
      'note': serializer.toJson<String?>(note),
      'actorId': serializer.toJson<String?>(actorId),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  StockMovementRow copyWith({
    String? id,
    String? storeId,
    String? productId,
    int? delta,
    String? reason,
    Value<String?> note = const Value.absent(),
    Value<String?> actorId = const Value.absent(),
    String? createdAt,
  }) => StockMovementRow(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    productId: productId ?? this.productId,
    delta: delta ?? this.delta,
    reason: reason ?? this.reason,
    note: note.present ? note.value : this.note,
    actorId: actorId.present ? actorId.value : this.actorId,
    createdAt: createdAt ?? this.createdAt,
  );
  StockMovementRow copyWithCompanion(StockMovementsCompanion data) {
    return StockMovementRow(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      productId: data.productId.present ? data.productId.value : this.productId,
      delta: data.delta.present ? data.delta.value : this.delta,
      reason: data.reason.present ? data.reason.value : this.reason,
      note: data.note.present ? data.note.value : this.note,
      actorId: data.actorId.present ? data.actorId.value : this.actorId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StockMovementRow(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('productId: $productId, ')
          ..write('delta: $delta, ')
          ..write('reason: $reason, ')
          ..write('note: $note, ')
          ..write('actorId: $actorId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    productId,
    delta,
    reason,
    note,
    actorId,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StockMovementRow &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.productId == this.productId &&
          other.delta == this.delta &&
          other.reason == this.reason &&
          other.note == this.note &&
          other.actorId == this.actorId &&
          other.createdAt == this.createdAt);
}

class StockMovementsCompanion extends UpdateCompanion<StockMovementRow> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<String> productId;
  final Value<int> delta;
  final Value<String> reason;
  final Value<String?> note;
  final Value<String?> actorId;
  final Value<String> createdAt;
  final Value<int> rowid;
  const StockMovementsCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.productId = const Value.absent(),
    this.delta = const Value.absent(),
    this.reason = const Value.absent(),
    this.note = const Value.absent(),
    this.actorId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StockMovementsCompanion.insert({
    required String id,
    required String storeId,
    required String productId,
    required int delta,
    required String reason,
    this.note = const Value.absent(),
    this.actorId = const Value.absent(),
    required String createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       productId = Value(productId),
       delta = Value(delta),
       reason = Value(reason),
       createdAt = Value(createdAt);
  static Insertable<StockMovementRow> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<String>? productId,
    Expression<int>? delta,
    Expression<String>? reason,
    Expression<String>? note,
    Expression<String>? actorId,
    Expression<String>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (productId != null) 'product_id': productId,
      if (delta != null) 'delta': delta,
      if (reason != null) 'reason': reason,
      if (note != null) 'note': note,
      if (actorId != null) 'actor_id': actorId,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StockMovementsCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<String>? productId,
    Value<int>? delta,
    Value<String>? reason,
    Value<String?>? note,
    Value<String?>? actorId,
    Value<String>? createdAt,
    Value<int>? rowid,
  }) {
    return StockMovementsCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      productId: productId ?? this.productId,
      delta: delta ?? this.delta,
      reason: reason ?? this.reason,
      note: note ?? this.note,
      actorId: actorId ?? this.actorId,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (delta.present) {
      map['delta'] = Variable<int>(delta.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (actorId.present) {
      map['actor_id'] = Variable<String>(actorId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StockMovementsCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('productId: $productId, ')
          ..write('delta: $delta, ')
          ..write('reason: $reason, ')
          ..write('note: $note, ')
          ..write('actorId: $actorId, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShiftsTable extends Shifts with TableInfo<$ShiftsTable, ShiftRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openingCashClpMeta = const VerificationMeta(
    'openingCashClp',
  );
  @override
  late final GeneratedColumn<int> openingCashClp = GeneratedColumn<int>(
    'opening_cash_clp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countedCashClpMeta = const VerificationMeta(
    'countedCashClp',
  );
  @override
  late final GeneratedColumn<int> countedCashClp = GeneratedColumn<int>(
    'counted_cash_clp',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _openedAtMeta = const VerificationMeta(
    'openedAt',
  );
  @override
  late final GeneratedColumn<String> openedAt = GeneratedColumn<String>(
    'opened_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _closedAtMeta = const VerificationMeta(
    'closedAt',
  );
  @override
  late final GeneratedColumn<String> closedAt = GeneratedColumn<String>(
    'closed_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    openingCashClp,
    countedCashClp,
    status,
    openedAt,
    closedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shifts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('opening_cash_clp')) {
      context.handle(
        _openingCashClpMeta,
        openingCashClp.isAcceptableOrUnknown(
          data['opening_cash_clp']!,
          _openingCashClpMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_openingCashClpMeta);
    }
    if (data.containsKey('counted_cash_clp')) {
      context.handle(
        _countedCashClpMeta,
        countedCashClp.isAcceptableOrUnknown(
          data['counted_cash_clp']!,
          _countedCashClpMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('opened_at')) {
      context.handle(
        _openedAtMeta,
        openedAt.isAcceptableOrUnknown(data['opened_at']!, _openedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_openedAtMeta);
    }
    if (data.containsKey('closed_at')) {
      context.handle(
        _closedAtMeta,
        closedAt.isAcceptableOrUnknown(data['closed_at']!, _closedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShiftRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      openingCashClp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}opening_cash_clp'],
      )!,
      countedCashClp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}counted_cash_clp'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      openedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opened_at'],
      )!,
      closedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}closed_at'],
      ),
    );
  }

  @override
  $ShiftsTable createAlias(String alias) {
    return $ShiftsTable(attachedDatabase, alias);
  }
}

class ShiftRow extends DataClass implements Insertable<ShiftRow> {
  final String id;
  final String storeId;
  final int openingCashClp;
  final int? countedCashClp;
  final String status;
  final String openedAt;
  final String? closedAt;
  const ShiftRow({
    required this.id,
    required this.storeId,
    required this.openingCashClp,
    this.countedCashClp,
    required this.status,
    required this.openedAt,
    this.closedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['opening_cash_clp'] = Variable<int>(openingCashClp);
    if (!nullToAbsent || countedCashClp != null) {
      map['counted_cash_clp'] = Variable<int>(countedCashClp);
    }
    map['status'] = Variable<String>(status);
    map['opened_at'] = Variable<String>(openedAt);
    if (!nullToAbsent || closedAt != null) {
      map['closed_at'] = Variable<String>(closedAt);
    }
    return map;
  }

  ShiftsCompanion toCompanion(bool nullToAbsent) {
    return ShiftsCompanion(
      id: Value(id),
      storeId: Value(storeId),
      openingCashClp: Value(openingCashClp),
      countedCashClp: countedCashClp == null && nullToAbsent
          ? const Value.absent()
          : Value(countedCashClp),
      status: Value(status),
      openedAt: Value(openedAt),
      closedAt: closedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(closedAt),
    );
  }

  factory ShiftRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftRow(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      openingCashClp: serializer.fromJson<int>(json['openingCashClp']),
      countedCashClp: serializer.fromJson<int?>(json['countedCashClp']),
      status: serializer.fromJson<String>(json['status']),
      openedAt: serializer.fromJson<String>(json['openedAt']),
      closedAt: serializer.fromJson<String?>(json['closedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'openingCashClp': serializer.toJson<int>(openingCashClp),
      'countedCashClp': serializer.toJson<int?>(countedCashClp),
      'status': serializer.toJson<String>(status),
      'openedAt': serializer.toJson<String>(openedAt),
      'closedAt': serializer.toJson<String?>(closedAt),
    };
  }

  ShiftRow copyWith({
    String? id,
    String? storeId,
    int? openingCashClp,
    Value<int?> countedCashClp = const Value.absent(),
    String? status,
    String? openedAt,
    Value<String?> closedAt = const Value.absent(),
  }) => ShiftRow(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    openingCashClp: openingCashClp ?? this.openingCashClp,
    countedCashClp: countedCashClp.present
        ? countedCashClp.value
        : this.countedCashClp,
    status: status ?? this.status,
    openedAt: openedAt ?? this.openedAt,
    closedAt: closedAt.present ? closedAt.value : this.closedAt,
  );
  ShiftRow copyWithCompanion(ShiftsCompanion data) {
    return ShiftRow(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      openingCashClp: data.openingCashClp.present
          ? data.openingCashClp.value
          : this.openingCashClp,
      countedCashClp: data.countedCashClp.present
          ? data.countedCashClp.value
          : this.countedCashClp,
      status: data.status.present ? data.status.value : this.status,
      openedAt: data.openedAt.present ? data.openedAt.value : this.openedAt,
      closedAt: data.closedAt.present ? data.closedAt.value : this.closedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftRow(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('openingCashClp: $openingCashClp, ')
          ..write('countedCashClp: $countedCashClp, ')
          ..write('status: $status, ')
          ..write('openedAt: $openedAt, ')
          ..write('closedAt: $closedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    openingCashClp,
    countedCashClp,
    status,
    openedAt,
    closedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftRow &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.openingCashClp == this.openingCashClp &&
          other.countedCashClp == this.countedCashClp &&
          other.status == this.status &&
          other.openedAt == this.openedAt &&
          other.closedAt == this.closedAt);
}

class ShiftsCompanion extends UpdateCompanion<ShiftRow> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<int> openingCashClp;
  final Value<int?> countedCashClp;
  final Value<String> status;
  final Value<String> openedAt;
  final Value<String?> closedAt;
  final Value<int> rowid;
  const ShiftsCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.openingCashClp = const Value.absent(),
    this.countedCashClp = const Value.absent(),
    this.status = const Value.absent(),
    this.openedAt = const Value.absent(),
    this.closedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShiftsCompanion.insert({
    required String id,
    required String storeId,
    required int openingCashClp,
    this.countedCashClp = const Value.absent(),
    required String status,
    required String openedAt,
    this.closedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       openingCashClp = Value(openingCashClp),
       status = Value(status),
       openedAt = Value(openedAt);
  static Insertable<ShiftRow> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<int>? openingCashClp,
    Expression<int>? countedCashClp,
    Expression<String>? status,
    Expression<String>? openedAt,
    Expression<String>? closedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (openingCashClp != null) 'opening_cash_clp': openingCashClp,
      if (countedCashClp != null) 'counted_cash_clp': countedCashClp,
      if (status != null) 'status': status,
      if (openedAt != null) 'opened_at': openedAt,
      if (closedAt != null) 'closed_at': closedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShiftsCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<int>? openingCashClp,
    Value<int?>? countedCashClp,
    Value<String>? status,
    Value<String>? openedAt,
    Value<String?>? closedAt,
    Value<int>? rowid,
  }) {
    return ShiftsCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      openingCashClp: openingCashClp ?? this.openingCashClp,
      countedCashClp: countedCashClp ?? this.countedCashClp,
      status: status ?? this.status,
      openedAt: openedAt ?? this.openedAt,
      closedAt: closedAt ?? this.closedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (openingCashClp.present) {
      map['opening_cash_clp'] = Variable<int>(openingCashClp.value);
    }
    if (countedCashClp.present) {
      map['counted_cash_clp'] = Variable<int>(countedCashClp.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (openedAt.present) {
      map['opened_at'] = Variable<String>(openedAt.value);
    }
    if (closedAt.present) {
      map['closed_at'] = Variable<String>(closedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftsCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('openingCashClp: $openingCashClp, ')
          ..write('countedCashClp: $countedCashClp, ')
          ..write('status: $status, ')
          ..write('openedAt: $openedAt, ')
          ..write('closedAt: $closedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, SaleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftIdMeta = const VerificationMeta(
    'shiftId',
  );
  @override
  late final GeneratedColumn<String> shiftId = GeneratedColumn<String>(
    'shift_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cartIdMeta = const VerificationMeta('cartId');
  @override
  late final GeneratedColumn<String> cartId = GeneratedColumn<String>(
    'cart_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalClpMeta = const VerificationMeta(
    'totalClp',
  );
  @override
  late final GeneratedColumn<int> totalClp = GeneratedColumn<int>(
    'total_clp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _changeClpMeta = const VerificationMeta(
    'changeClp',
  );
  @override
  late final GeneratedColumn<int> changeClp = GeneratedColumn<int>(
    'change_clp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('CONFIRMADA'),
  );
  static const VerificationMeta _dteStatusMeta = const VerificationMeta(
    'dteStatus',
  );
  @override
  late final GeneratedColumn<String> dteStatus = GeneratedColumn<String>(
    'dte_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('PENDIENTE_DTE'),
  );
  static const VerificationMeta _folioMeta = const VerificationMeta('folio');
  @override
  late final GeneratedColumn<int> folio = GeneratedColumn<int>(
    'folio',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pdfUrlMeta = const VerificationMeta('pdfUrl');
  @override
  late final GeneratedColumn<String> pdfUrl = GeneratedColumn<String>(
    'pdf_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _confirmedByUserIdMeta = const VerificationMeta(
    'confirmedByUserId',
  );
  @override
  late final GeneratedColumn<String> confirmedByUserId =
      GeneratedColumn<String>(
        'confirmed_by_user_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    shiftId,
    cartId,
    totalClp,
    changeClp,
    createdAt,
    status,
    dteStatus,
    folio,
    pdfUrl,
    confirmedByUserId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('shift_id')) {
      context.handle(
        _shiftIdMeta,
        shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta),
      );
    } else if (isInserting) {
      context.missing(_shiftIdMeta);
    }
    if (data.containsKey('cart_id')) {
      context.handle(
        _cartIdMeta,
        cartId.isAcceptableOrUnknown(data['cart_id']!, _cartIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cartIdMeta);
    }
    if (data.containsKey('total_clp')) {
      context.handle(
        _totalClpMeta,
        totalClp.isAcceptableOrUnknown(data['total_clp']!, _totalClpMeta),
      );
    } else if (isInserting) {
      context.missing(_totalClpMeta);
    }
    if (data.containsKey('change_clp')) {
      context.handle(
        _changeClpMeta,
        changeClp.isAcceptableOrUnknown(data['change_clp']!, _changeClpMeta),
      );
    } else if (isInserting) {
      context.missing(_changeClpMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('dte_status')) {
      context.handle(
        _dteStatusMeta,
        dteStatus.isAcceptableOrUnknown(data['dte_status']!, _dteStatusMeta),
      );
    }
    if (data.containsKey('folio')) {
      context.handle(
        _folioMeta,
        folio.isAcceptableOrUnknown(data['folio']!, _folioMeta),
      );
    }
    if (data.containsKey('pdf_url')) {
      context.handle(
        _pdfUrlMeta,
        pdfUrl.isAcceptableOrUnknown(data['pdf_url']!, _pdfUrlMeta),
      );
    }
    if (data.containsKey('confirmed_by_user_id')) {
      context.handle(
        _confirmedByUserIdMeta,
        confirmedByUserId.isAcceptableOrUnknown(
          data['confirmed_by_user_id']!,
          _confirmedByUserIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      shiftId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}shift_id'],
      )!,
      cartId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cart_id'],
      )!,
      totalClp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_clp'],
      )!,
      changeClp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}change_clp'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      dteStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dte_status'],
      )!,
      folio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}folio'],
      ),
      pdfUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pdf_url'],
      ),
      confirmedByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}confirmed_by_user_id'],
      ),
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class SaleRow extends DataClass implements Insertable<SaleRow> {
  final String id;
  final String storeId;
  final String shiftId;
  final String cartId;
  final int totalClp;
  final int changeClp;
  final String createdAt;
  final String status;
  final String dteStatus;
  final int? folio;
  final String? pdfUrl;
  final String? confirmedByUserId;
  const SaleRow({
    required this.id,
    required this.storeId,
    required this.shiftId,
    required this.cartId,
    required this.totalClp,
    required this.changeClp,
    required this.createdAt,
    required this.status,
    required this.dteStatus,
    this.folio,
    this.pdfUrl,
    this.confirmedByUserId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['shift_id'] = Variable<String>(shiftId);
    map['cart_id'] = Variable<String>(cartId);
    map['total_clp'] = Variable<int>(totalClp);
    map['change_clp'] = Variable<int>(changeClp);
    map['created_at'] = Variable<String>(createdAt);
    map['status'] = Variable<String>(status);
    map['dte_status'] = Variable<String>(dteStatus);
    if (!nullToAbsent || folio != null) {
      map['folio'] = Variable<int>(folio);
    }
    if (!nullToAbsent || pdfUrl != null) {
      map['pdf_url'] = Variable<String>(pdfUrl);
    }
    if (!nullToAbsent || confirmedByUserId != null) {
      map['confirmed_by_user_id'] = Variable<String>(confirmedByUserId);
    }
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      storeId: Value(storeId),
      shiftId: Value(shiftId),
      cartId: Value(cartId),
      totalClp: Value(totalClp),
      changeClp: Value(changeClp),
      createdAt: Value(createdAt),
      status: Value(status),
      dteStatus: Value(dteStatus),
      folio: folio == null && nullToAbsent
          ? const Value.absent()
          : Value(folio),
      pdfUrl: pdfUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(pdfUrl),
      confirmedByUserId: confirmedByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(confirmedByUserId),
    );
  }

  factory SaleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleRow(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      shiftId: serializer.fromJson<String>(json['shiftId']),
      cartId: serializer.fromJson<String>(json['cartId']),
      totalClp: serializer.fromJson<int>(json['totalClp']),
      changeClp: serializer.fromJson<int>(json['changeClp']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      status: serializer.fromJson<String>(json['status']),
      dteStatus: serializer.fromJson<String>(json['dteStatus']),
      folio: serializer.fromJson<int?>(json['folio']),
      pdfUrl: serializer.fromJson<String?>(json['pdfUrl']),
      confirmedByUserId: serializer.fromJson<String?>(
        json['confirmedByUserId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'shiftId': serializer.toJson<String>(shiftId),
      'cartId': serializer.toJson<String>(cartId),
      'totalClp': serializer.toJson<int>(totalClp),
      'changeClp': serializer.toJson<int>(changeClp),
      'createdAt': serializer.toJson<String>(createdAt),
      'status': serializer.toJson<String>(status),
      'dteStatus': serializer.toJson<String>(dteStatus),
      'folio': serializer.toJson<int?>(folio),
      'pdfUrl': serializer.toJson<String?>(pdfUrl),
      'confirmedByUserId': serializer.toJson<String?>(confirmedByUserId),
    };
  }

  SaleRow copyWith({
    String? id,
    String? storeId,
    String? shiftId,
    String? cartId,
    int? totalClp,
    int? changeClp,
    String? createdAt,
    String? status,
    String? dteStatus,
    Value<int?> folio = const Value.absent(),
    Value<String?> pdfUrl = const Value.absent(),
    Value<String?> confirmedByUserId = const Value.absent(),
  }) => SaleRow(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    shiftId: shiftId ?? this.shiftId,
    cartId: cartId ?? this.cartId,
    totalClp: totalClp ?? this.totalClp,
    changeClp: changeClp ?? this.changeClp,
    createdAt: createdAt ?? this.createdAt,
    status: status ?? this.status,
    dteStatus: dteStatus ?? this.dteStatus,
    folio: folio.present ? folio.value : this.folio,
    pdfUrl: pdfUrl.present ? pdfUrl.value : this.pdfUrl,
    confirmedByUserId: confirmedByUserId.present
        ? confirmedByUserId.value
        : this.confirmedByUserId,
  );
  SaleRow copyWithCompanion(SalesCompanion data) {
    return SaleRow(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      cartId: data.cartId.present ? data.cartId.value : this.cartId,
      totalClp: data.totalClp.present ? data.totalClp.value : this.totalClp,
      changeClp: data.changeClp.present ? data.changeClp.value : this.changeClp,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      status: data.status.present ? data.status.value : this.status,
      dteStatus: data.dteStatus.present ? data.dteStatus.value : this.dteStatus,
      folio: data.folio.present ? data.folio.value : this.folio,
      pdfUrl: data.pdfUrl.present ? data.pdfUrl.value : this.pdfUrl,
      confirmedByUserId: data.confirmedByUserId.present
          ? data.confirmedByUserId.value
          : this.confirmedByUserId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleRow(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('shiftId: $shiftId, ')
          ..write('cartId: $cartId, ')
          ..write('totalClp: $totalClp, ')
          ..write('changeClp: $changeClp, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('dteStatus: $dteStatus, ')
          ..write('folio: $folio, ')
          ..write('pdfUrl: $pdfUrl, ')
          ..write('confirmedByUserId: $confirmedByUserId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    shiftId,
    cartId,
    totalClp,
    changeClp,
    createdAt,
    status,
    dteStatus,
    folio,
    pdfUrl,
    confirmedByUserId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleRow &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.shiftId == this.shiftId &&
          other.cartId == this.cartId &&
          other.totalClp == this.totalClp &&
          other.changeClp == this.changeClp &&
          other.createdAt == this.createdAt &&
          other.status == this.status &&
          other.dteStatus == this.dteStatus &&
          other.folio == this.folio &&
          other.pdfUrl == this.pdfUrl &&
          other.confirmedByUserId == this.confirmedByUserId);
}

class SalesCompanion extends UpdateCompanion<SaleRow> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<String> shiftId;
  final Value<String> cartId;
  final Value<int> totalClp;
  final Value<int> changeClp;
  final Value<String> createdAt;
  final Value<String> status;
  final Value<String> dteStatus;
  final Value<int?> folio;
  final Value<String?> pdfUrl;
  final Value<String?> confirmedByUserId;
  final Value<int> rowid;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.cartId = const Value.absent(),
    this.totalClp = const Value.absent(),
    this.changeClp = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.status = const Value.absent(),
    this.dteStatus = const Value.absent(),
    this.folio = const Value.absent(),
    this.pdfUrl = const Value.absent(),
    this.confirmedByUserId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SalesCompanion.insert({
    required String id,
    required String storeId,
    required String shiftId,
    required String cartId,
    required int totalClp,
    required int changeClp,
    required String createdAt,
    this.status = const Value.absent(),
    this.dteStatus = const Value.absent(),
    this.folio = const Value.absent(),
    this.pdfUrl = const Value.absent(),
    this.confirmedByUserId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       shiftId = Value(shiftId),
       cartId = Value(cartId),
       totalClp = Value(totalClp),
       changeClp = Value(changeClp),
       createdAt = Value(createdAt);
  static Insertable<SaleRow> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<String>? shiftId,
    Expression<String>? cartId,
    Expression<int>? totalClp,
    Expression<int>? changeClp,
    Expression<String>? createdAt,
    Expression<String>? status,
    Expression<String>? dteStatus,
    Expression<int>? folio,
    Expression<String>? pdfUrl,
    Expression<String>? confirmedByUserId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (shiftId != null) 'shift_id': shiftId,
      if (cartId != null) 'cart_id': cartId,
      if (totalClp != null) 'total_clp': totalClp,
      if (changeClp != null) 'change_clp': changeClp,
      if (createdAt != null) 'created_at': createdAt,
      if (status != null) 'status': status,
      if (dteStatus != null) 'dte_status': dteStatus,
      if (folio != null) 'folio': folio,
      if (pdfUrl != null) 'pdf_url': pdfUrl,
      if (confirmedByUserId != null) 'confirmed_by_user_id': confirmedByUserId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SalesCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<String>? shiftId,
    Value<String>? cartId,
    Value<int>? totalClp,
    Value<int>? changeClp,
    Value<String>? createdAt,
    Value<String>? status,
    Value<String>? dteStatus,
    Value<int?>? folio,
    Value<String?>? pdfUrl,
    Value<String?>? confirmedByUserId,
    Value<int>? rowid,
  }) {
    return SalesCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      shiftId: shiftId ?? this.shiftId,
      cartId: cartId ?? this.cartId,
      totalClp: totalClp ?? this.totalClp,
      changeClp: changeClp ?? this.changeClp,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
      dteStatus: dteStatus ?? this.dteStatus,
      folio: folio ?? this.folio,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      confirmedByUserId: confirmedByUserId ?? this.confirmedByUserId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<String>(shiftId.value);
    }
    if (cartId.present) {
      map['cart_id'] = Variable<String>(cartId.value);
    }
    if (totalClp.present) {
      map['total_clp'] = Variable<int>(totalClp.value);
    }
    if (changeClp.present) {
      map['change_clp'] = Variable<int>(changeClp.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (dteStatus.present) {
      map['dte_status'] = Variable<String>(dteStatus.value);
    }
    if (folio.present) {
      map['folio'] = Variable<int>(folio.value);
    }
    if (pdfUrl.present) {
      map['pdf_url'] = Variable<String>(pdfUrl.value);
    }
    if (confirmedByUserId.present) {
      map['confirmed_by_user_id'] = Variable<String>(confirmedByUserId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('shiftId: $shiftId, ')
          ..write('cartId: $cartId, ')
          ..write('totalClp: $totalClp, ')
          ..write('changeClp: $changeClp, ')
          ..write('createdAt: $createdAt, ')
          ..write('status: $status, ')
          ..write('dteStatus: $dteStatus, ')
          ..write('folio: $folio, ')
          ..write('pdfUrl: $pdfUrl, ')
          ..write('confirmedByUserId: $confirmedByUserId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SaleLinesTable extends SaleLines
    with TableInfo<$SaleLinesTable, SaleLineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SaleLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productIdMeta = const VerificationMeta(
    'productId',
  );
  @override
  late final GeneratedColumn<String> productId = GeneratedColumn<String>(
    'product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _productNameMeta = const VerificationMeta(
    'productName',
  );
  @override
  late final GeneratedColumn<String> productName = GeneratedColumn<String>(
    'product_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitPriceClpMeta = const VerificationMeta(
    'unitPriceClp',
  );
  @override
  late final GeneratedColumn<int> unitPriceClp = GeneratedColumn<int>(
    'unit_price_clp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    saleId,
    productId,
    productName,
    quantity,
    unitPriceClp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sale_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<SaleLineRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('product_name')) {
      context.handle(
        _productNameMeta,
        productName.isAcceptableOrUnknown(
          data['product_name']!,
          _productNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_productNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit_price_clp')) {
      context.handle(
        _unitPriceClpMeta,
        unitPriceClp.isAcceptableOrUnknown(
          data['unit_price_clp']!,
          _unitPriceClpMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitPriceClpMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SaleLineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SaleLineRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      productName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quantity'],
      )!,
      unitPriceClp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unit_price_clp'],
      )!,
    );
  }

  @override
  $SaleLinesTable createAlias(String alias) {
    return $SaleLinesTable(attachedDatabase, alias);
  }
}

class SaleLineRow extends DataClass implements Insertable<SaleLineRow> {
  final String id;
  final String saleId;
  final String productId;
  final String productName;
  final int quantity;
  final int unitPriceClp;
  const SaleLineRow({
    required this.id,
    required this.saleId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPriceClp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sale_id'] = Variable<String>(saleId);
    map['product_id'] = Variable<String>(productId);
    map['product_name'] = Variable<String>(productName);
    map['quantity'] = Variable<int>(quantity);
    map['unit_price_clp'] = Variable<int>(unitPriceClp);
    return map;
  }

  SaleLinesCompanion toCompanion(bool nullToAbsent) {
    return SaleLinesCompanion(
      id: Value(id),
      saleId: Value(saleId),
      productId: Value(productId),
      productName: Value(productName),
      quantity: Value(quantity),
      unitPriceClp: Value(unitPriceClp),
    );
  }

  factory SaleLineRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SaleLineRow(
      id: serializer.fromJson<String>(json['id']),
      saleId: serializer.fromJson<String>(json['saleId']),
      productId: serializer.fromJson<String>(json['productId']),
      productName: serializer.fromJson<String>(json['productName']),
      quantity: serializer.fromJson<int>(json['quantity']),
      unitPriceClp: serializer.fromJson<int>(json['unitPriceClp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'saleId': serializer.toJson<String>(saleId),
      'productId': serializer.toJson<String>(productId),
      'productName': serializer.toJson<String>(productName),
      'quantity': serializer.toJson<int>(quantity),
      'unitPriceClp': serializer.toJson<int>(unitPriceClp),
    };
  }

  SaleLineRow copyWith({
    String? id,
    String? saleId,
    String? productId,
    String? productName,
    int? quantity,
    int? unitPriceClp,
  }) => SaleLineRow(
    id: id ?? this.id,
    saleId: saleId ?? this.saleId,
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    quantity: quantity ?? this.quantity,
    unitPriceClp: unitPriceClp ?? this.unitPriceClp,
  );
  SaleLineRow copyWithCompanion(SaleLinesCompanion data) {
    return SaleLineRow(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      productId: data.productId.present ? data.productId.value : this.productId,
      productName: data.productName.present
          ? data.productName.value
          : this.productName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unitPriceClp: data.unitPriceClp.present
          ? data.unitPriceClp.value
          : this.unitPriceClp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SaleLineRow(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceClp: $unitPriceClp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, saleId, productId, productName, quantity, unitPriceClp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SaleLineRow &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.quantity == this.quantity &&
          other.unitPriceClp == this.unitPriceClp);
}

class SaleLinesCompanion extends UpdateCompanion<SaleLineRow> {
  final Value<String> id;
  final Value<String> saleId;
  final Value<String> productId;
  final Value<String> productName;
  final Value<int> quantity;
  final Value<int> unitPriceClp;
  final Value<int> rowid;
  const SaleLinesCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPriceClp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SaleLinesCompanion.insert({
    required String id,
    required String saleId,
    required String productId,
    required String productName,
    required int quantity,
    required int unitPriceClp,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       saleId = Value(saleId),
       productId = Value(productId),
       productName = Value(productName),
       quantity = Value(quantity),
       unitPriceClp = Value(unitPriceClp);
  static Insertable<SaleLineRow> custom({
    Expression<String>? id,
    Expression<String>? saleId,
    Expression<String>? productId,
    Expression<String>? productName,
    Expression<int>? quantity,
    Expression<int>? unitPriceClp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (quantity != null) 'quantity': quantity,
      if (unitPriceClp != null) 'unit_price_clp': unitPriceClp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SaleLinesCompanion copyWith({
    Value<String>? id,
    Value<String>? saleId,
    Value<String>? productId,
    Value<String>? productName,
    Value<int>? quantity,
    Value<int>? unitPriceClp,
    Value<int>? rowid,
  }) {
    return SaleLinesCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPriceClp: unitPriceClp ?? this.unitPriceClp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (productName.present) {
      map['product_name'] = Variable<String>(productName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (unitPriceClp.present) {
      map['unit_price_clp'] = Variable<int>(unitPriceClp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SaleLinesCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceClp: $unitPriceClp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentsTable extends Payments
    with TableInfo<$PaymentsTable, PaymentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountClpMeta = const VerificationMeta(
    'amountClp',
  );
  @override
  late final GeneratedColumn<int> amountClp = GeneratedColumn<int>(
    'amount_clp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, saleId, method, amountClp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payments';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('amount_clp')) {
      context.handle(
        _amountClpMeta,
        amountClp.isAcceptableOrUnknown(data['amount_clp']!, _amountClpMeta),
      );
    } else if (isInserting) {
      context.missing(_amountClpMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_id'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      amountClp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_clp'],
      )!,
    );
  }

  @override
  $PaymentsTable createAlias(String alias) {
    return $PaymentsTable(attachedDatabase, alias);
  }
}

class PaymentRow extends DataClass implements Insertable<PaymentRow> {
  final String id;
  final String saleId;
  final String method;
  final int amountClp;
  const PaymentRow({
    required this.id,
    required this.saleId,
    required this.method,
    required this.amountClp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['sale_id'] = Variable<String>(saleId);
    map['method'] = Variable<String>(method);
    map['amount_clp'] = Variable<int>(amountClp);
    return map;
  }

  PaymentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentsCompanion(
      id: Value(id),
      saleId: Value(saleId),
      method: Value(method),
      amountClp: Value(amountClp),
    );
  }

  factory PaymentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentRow(
      id: serializer.fromJson<String>(json['id']),
      saleId: serializer.fromJson<String>(json['saleId']),
      method: serializer.fromJson<String>(json['method']),
      amountClp: serializer.fromJson<int>(json['amountClp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'saleId': serializer.toJson<String>(saleId),
      'method': serializer.toJson<String>(method),
      'amountClp': serializer.toJson<int>(amountClp),
    };
  }

  PaymentRow copyWith({
    String? id,
    String? saleId,
    String? method,
    int? amountClp,
  }) => PaymentRow(
    id: id ?? this.id,
    saleId: saleId ?? this.saleId,
    method: method ?? this.method,
    amountClp: amountClp ?? this.amountClp,
  );
  PaymentRow copyWithCompanion(PaymentsCompanion data) {
    return PaymentRow(
      id: data.id.present ? data.id.value : this.id,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      method: data.method.present ? data.method.value : this.method,
      amountClp: data.amountClp.present ? data.amountClp.value : this.amountClp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentRow(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('method: $method, ')
          ..write('amountClp: $amountClp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, saleId, method, amountClp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentRow &&
          other.id == this.id &&
          other.saleId == this.saleId &&
          other.method == this.method &&
          other.amountClp == this.amountClp);
}

class PaymentsCompanion extends UpdateCompanion<PaymentRow> {
  final Value<String> id;
  final Value<String> saleId;
  final Value<String> method;
  final Value<int> amountClp;
  final Value<int> rowid;
  const PaymentsCompanion({
    this.id = const Value.absent(),
    this.saleId = const Value.absent(),
    this.method = const Value.absent(),
    this.amountClp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentsCompanion.insert({
    required String id,
    required String saleId,
    required String method,
    required int amountClp,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       saleId = Value(saleId),
       method = Value(method),
       amountClp = Value(amountClp);
  static Insertable<PaymentRow> custom({
    Expression<String>? id,
    Expression<String>? saleId,
    Expression<String>? method,
    Expression<int>? amountClp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (saleId != null) 'sale_id': saleId,
      if (method != null) 'method': method,
      if (amountClp != null) 'amount_clp': amountClp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentsCompanion copyWith({
    Value<String>? id,
    Value<String>? saleId,
    Value<String>? method,
    Value<int>? amountClp,
    Value<int>? rowid,
  }) {
    return PaymentsCompanion(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      method: method ?? this.method,
      amountClp: amountClp ?? this.amountClp,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (amountClp.present) {
      map['amount_clp'] = Variable<int>(amountClp.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentsCompanion(')
          ..write('id: $id, ')
          ..write('saleId: $saleId, ')
          ..write('method: $method, ')
          ..write('amountClp: $amountClp, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DteQueueTable extends DteQueue
    with TableInfo<$DteQueueTable, DteQueueRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DteQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
    'sale_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    saleId,
    storeId,
    attempts,
    lastError,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dte_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<DteQueueRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {saleId};
  @override
  DteQueueRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DteQueueRow(
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DteQueueTable createAlias(String alias) {
    return $DteQueueTable(attachedDatabase, alias);
  }
}

class DteQueueRow extends DataClass implements Insertable<DteQueueRow> {
  final String saleId;
  final String storeId;
  final int attempts;
  final String? lastError;
  final String createdAt;
  const DteQueueRow({
    required this.saleId,
    required this.storeId,
    required this.attempts,
    this.lastError,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['sale_id'] = Variable<String>(saleId);
    map['store_id'] = Variable<String>(storeId);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  DteQueueCompanion toCompanion(bool nullToAbsent) {
    return DteQueueCompanion(
      saleId: Value(saleId),
      storeId: Value(storeId),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      createdAt: Value(createdAt),
    );
  }

  factory DteQueueRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DteQueueRow(
      saleId: serializer.fromJson<String>(json['saleId']),
      storeId: serializer.fromJson<String>(json['storeId']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'saleId': serializer.toJson<String>(saleId),
      'storeId': serializer.toJson<String>(storeId),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  DteQueueRow copyWith({
    String? saleId,
    String? storeId,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
    String? createdAt,
  }) => DteQueueRow(
    saleId: saleId ?? this.saleId,
    storeId: storeId ?? this.storeId,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
  );
  DteQueueRow copyWithCompanion(DteQueueCompanion data) {
    return DteQueueRow(
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DteQueueRow(')
          ..write('saleId: $saleId, ')
          ..write('storeId: $storeId, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(saleId, storeId, attempts, lastError, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DteQueueRow &&
          other.saleId == this.saleId &&
          other.storeId == this.storeId &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt);
}

class DteQueueCompanion extends UpdateCompanion<DteQueueRow> {
  final Value<String> saleId;
  final Value<String> storeId;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<String> createdAt;
  final Value<int> rowid;
  const DteQueueCompanion({
    this.saleId = const Value.absent(),
    this.storeId = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DteQueueCompanion.insert({
    required String saleId,
    required String storeId,
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    required String createdAt,
    this.rowid = const Value.absent(),
  }) : saleId = Value(saleId),
       storeId = Value(storeId),
       createdAt = Value(createdAt);
  static Insertable<DteQueueRow> custom({
    Expression<String>? saleId,
    Expression<String>? storeId,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<String>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (saleId != null) 'sale_id': saleId,
      if (storeId != null) 'store_id': storeId,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DteQueueCompanion copyWith({
    Value<String>? saleId,
    Value<String>? storeId,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<String>? createdAt,
    Value<int>? rowid,
  }) {
    return DteQueueCompanion(
      saleId: saleId ?? this.saleId,
      storeId: storeId ?? this.storeId,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DteQueueCompanion(')
          ..write('saleId: $saleId, ')
          ..write('storeId: $storeId, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UsersTable extends Users with TableInfo<$UsersTable, UserRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pinHashMeta = const VerificationMeta(
    'pinHash',
  );
  @override
  late final GeneratedColumn<String> pinHash = GeneratedColumn<String>(
    'pin_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userRutMeta = const VerificationMeta(
    'userRut',
  );
  @override
  late final GeneratedColumn<String> userRut = GeneratedColumn<String>(
    'user_rut',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    role,
    pinHash,
    displayName,
    username,
    firstName,
    lastName,
    userRut,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('pin_hash')) {
      context.handle(
        _pinHashMeta,
        pinHash.isAcceptableOrUnknown(data['pin_hash']!, _pinHashMeta),
      );
    } else if (isInserting) {
      context.missing(_pinHashMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('user_rut')) {
      context.handle(
        _userRutMeta,
        userRut.isAcceptableOrUnknown(data['user_rut']!, _userRutMeta),
      );
    } else if (isInserting) {
      context.missing(_userRutMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      pinHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pin_hash'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      userRut: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_rut'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class UserRow extends DataClass implements Insertable<UserRow> {
  final String id;
  final String storeId;
  final String role;
  final String pinHash;
  final String displayName;
  final String username;
  final String firstName;
  final String lastName;
  final String userRut;
  const UserRow({
    required this.id,
    required this.storeId,
    required this.role,
    required this.pinHash,
    required this.displayName,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.userRut,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['role'] = Variable<String>(role);
    map['pin_hash'] = Variable<String>(pinHash);
    map['display_name'] = Variable<String>(displayName);
    map['username'] = Variable<String>(username);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['user_rut'] = Variable<String>(userRut);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      storeId: Value(storeId),
      role: Value(role),
      pinHash: Value(pinHash),
      displayName: Value(displayName),
      username: Value(username),
      firstName: Value(firstName),
      lastName: Value(lastName),
      userRut: Value(userRut),
    );
  }

  factory UserRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserRow(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      role: serializer.fromJson<String>(json['role']),
      pinHash: serializer.fromJson<String>(json['pinHash']),
      displayName: serializer.fromJson<String>(json['displayName']),
      username: serializer.fromJson<String>(json['username']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      userRut: serializer.fromJson<String>(json['userRut']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'role': serializer.toJson<String>(role),
      'pinHash': serializer.toJson<String>(pinHash),
      'displayName': serializer.toJson<String>(displayName),
      'username': serializer.toJson<String>(username),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'userRut': serializer.toJson<String>(userRut),
    };
  }

  UserRow copyWith({
    String? id,
    String? storeId,
    String? role,
    String? pinHash,
    String? displayName,
    String? username,
    String? firstName,
    String? lastName,
    String? userRut,
  }) => UserRow(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    role: role ?? this.role,
    pinHash: pinHash ?? this.pinHash,
    displayName: displayName ?? this.displayName,
    username: username ?? this.username,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    userRut: userRut ?? this.userRut,
  );
  UserRow copyWithCompanion(UsersCompanion data) {
    return UserRow(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      role: data.role.present ? data.role.value : this.role,
      pinHash: data.pinHash.present ? data.pinHash.value : this.pinHash,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      username: data.username.present ? data.username.value : this.username,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      userRut: data.userRut.present ? data.userRut.value : this.userRut,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserRow(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('role: $role, ')
          ..write('pinHash: $pinHash, ')
          ..write('displayName: $displayName, ')
          ..write('username: $username, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('userRut: $userRut')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    role,
    pinHash,
    displayName,
    username,
    firstName,
    lastName,
    userRut,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserRow &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.role == this.role &&
          other.pinHash == this.pinHash &&
          other.displayName == this.displayName &&
          other.username == this.username &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.userRut == this.userRut);
}

class UsersCompanion extends UpdateCompanion<UserRow> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<String> role;
  final Value<String> pinHash;
  final Value<String> displayName;
  final Value<String> username;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<String> userRut;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.role = const Value.absent(),
    this.pinHash = const Value.absent(),
    this.displayName = const Value.absent(),
    this.username = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.userRut = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String storeId,
    required String role,
    required String pinHash,
    required String displayName,
    required String username,
    required String firstName,
    required String lastName,
    required String userRut,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       role = Value(role),
       pinHash = Value(pinHash),
       displayName = Value(displayName),
       username = Value(username),
       firstName = Value(firstName),
       lastName = Value(lastName),
       userRut = Value(userRut);
  static Insertable<UserRow> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<String>? role,
    Expression<String>? pinHash,
    Expression<String>? displayName,
    Expression<String>? username,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<String>? userRut,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (role != null) 'role': role,
      if (pinHash != null) 'pin_hash': pinHash,
      if (displayName != null) 'display_name': displayName,
      if (username != null) 'username': username,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (userRut != null) 'user_rut': userRut,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<String>? role,
    Value<String>? pinHash,
    Value<String>? displayName,
    Value<String>? username,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<String>? userRut,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      role: role ?? this.role,
      pinHash: pinHash ?? this.pinHash,
      displayName: displayName ?? this.displayName,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userRut: userRut ?? this.userRut,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (pinHash.present) {
      map['pin_hash'] = Variable<String>(pinHash.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (userRut.present) {
      map['user_rut'] = Variable<String>(userRut.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('role: $role, ')
          ..write('pinHash: $pinHash, ')
          ..write('displayName: $displayName, ')
          ..write('username: $username, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('userRut: $userRut, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CollaboratorsTable extends Collaborators
    with TableInfo<$CollaboratorsTable, CollaboratorRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollaboratorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sellerCodeMeta = const VerificationMeta(
    'sellerCode',
  );
  @override
  late final GeneratedColumn<String> sellerCode = GeneratedColumn<String>(
    'seller_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    sellerCode,
    firstName,
    lastName,
    active,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collaborators';
  @override
  VerificationContext validateIntegrity(
    Insertable<CollaboratorRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('seller_code')) {
      context.handle(
        _sellerCodeMeta,
        sellerCode.isAcceptableOrUnknown(data['seller_code']!, _sellerCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_sellerCodeMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    } else if (isInserting) {
      context.missing(_firstNameMeta);
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CollaboratorRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CollaboratorRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      sellerCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seller_code'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $CollaboratorsTable createAlias(String alias) {
    return $CollaboratorsTable(attachedDatabase, alias);
  }
}

class CollaboratorRow extends DataClass implements Insertable<CollaboratorRow> {
  final String id;
  final String storeId;
  final String sellerCode;
  final String firstName;
  final String lastName;
  final bool active;
  const CollaboratorRow({
    required this.id,
    required this.storeId,
    required this.sellerCode,
    required this.firstName,
    required this.lastName,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['seller_code'] = Variable<String>(sellerCode);
    map['first_name'] = Variable<String>(firstName);
    map['last_name'] = Variable<String>(lastName);
    map['active'] = Variable<bool>(active);
    return map;
  }

  CollaboratorsCompanion toCompanion(bool nullToAbsent) {
    return CollaboratorsCompanion(
      id: Value(id),
      storeId: Value(storeId),
      sellerCode: Value(sellerCode),
      firstName: Value(firstName),
      lastName: Value(lastName),
      active: Value(active),
    );
  }

  factory CollaboratorRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CollaboratorRow(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      sellerCode: serializer.fromJson<String>(json['sellerCode']),
      firstName: serializer.fromJson<String>(json['firstName']),
      lastName: serializer.fromJson<String>(json['lastName']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'sellerCode': serializer.toJson<String>(sellerCode),
      'firstName': serializer.toJson<String>(firstName),
      'lastName': serializer.toJson<String>(lastName),
      'active': serializer.toJson<bool>(active),
    };
  }

  CollaboratorRow copyWith({
    String? id,
    String? storeId,
    String? sellerCode,
    String? firstName,
    String? lastName,
    bool? active,
  }) => CollaboratorRow(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    sellerCode: sellerCode ?? this.sellerCode,
    firstName: firstName ?? this.firstName,
    lastName: lastName ?? this.lastName,
    active: active ?? this.active,
  );
  CollaboratorRow copyWithCompanion(CollaboratorsCompanion data) {
    return CollaboratorRow(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      sellerCode: data.sellerCode.present
          ? data.sellerCode.value
          : this.sellerCode,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CollaboratorRow(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('sellerCode: $sellerCode, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, storeId, sellerCode, firstName, lastName, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CollaboratorRow &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.sellerCode == this.sellerCode &&
          other.firstName == this.firstName &&
          other.lastName == this.lastName &&
          other.active == this.active);
}

class CollaboratorsCompanion extends UpdateCompanion<CollaboratorRow> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<String> sellerCode;
  final Value<String> firstName;
  final Value<String> lastName;
  final Value<bool> active;
  final Value<int> rowid;
  const CollaboratorsCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.sellerCode = const Value.absent(),
    this.firstName = const Value.absent(),
    this.lastName = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CollaboratorsCompanion.insert({
    required String id,
    required String storeId,
    required String sellerCode,
    required String firstName,
    required String lastName,
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       sellerCode = Value(sellerCode),
       firstName = Value(firstName),
       lastName = Value(lastName);
  static Insertable<CollaboratorRow> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<String>? sellerCode,
    Expression<String>? firstName,
    Expression<String>? lastName,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (sellerCode != null) 'seller_code': sellerCode,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CollaboratorsCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<String>? sellerCode,
    Value<String>? firstName,
    Value<String>? lastName,
    Value<bool>? active,
    Value<int>? rowid,
  }) {
    return CollaboratorsCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      sellerCode: sellerCode ?? this.sellerCode,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (sellerCode.present) {
      map['seller_code'] = Variable<String>(sellerCode.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollaboratorsCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('sellerCode: $sellerCode, ')
          ..write('firstName: $firstName, ')
          ..write('lastName: $lastName, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DteFolioCountersTable extends DteFolioCounters
    with TableInfo<$DteFolioCountersTable, DteFolioCounterRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DteFolioCountersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _documentTypeMeta = const VerificationMeta(
    'documentType',
  );
  @override
  late final GeneratedColumn<int> documentType = GeneratedColumn<int>(
    'document_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextFolioMeta = const VerificationMeta(
    'nextFolio',
  );
  @override
  late final GeneratedColumn<int> nextFolio = GeneratedColumn<int>(
    'next_folio',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cafDesdeMeta = const VerificationMeta(
    'cafDesde',
  );
  @override
  late final GeneratedColumn<int> cafDesde = GeneratedColumn<int>(
    'caf_desde',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cafHastaMeta = const VerificationMeta(
    'cafHasta',
  );
  @override
  late final GeneratedColumn<int> cafHasta = GeneratedColumn<int>(
    'caf_hasta',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    storeId,
    documentType,
    nextFolio,
    cafDesde,
    cafHasta,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'dte_folio_counters';
  @override
  VerificationContext validateIntegrity(
    Insertable<DteFolioCounterRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('document_type')) {
      context.handle(
        _documentTypeMeta,
        documentType.isAcceptableOrUnknown(
          data['document_type']!,
          _documentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_documentTypeMeta);
    }
    if (data.containsKey('next_folio')) {
      context.handle(
        _nextFolioMeta,
        nextFolio.isAcceptableOrUnknown(data['next_folio']!, _nextFolioMeta),
      );
    } else if (isInserting) {
      context.missing(_nextFolioMeta);
    }
    if (data.containsKey('caf_desde')) {
      context.handle(
        _cafDesdeMeta,
        cafDesde.isAcceptableOrUnknown(data['caf_desde']!, _cafDesdeMeta),
      );
    } else if (isInserting) {
      context.missing(_cafDesdeMeta);
    }
    if (data.containsKey('caf_hasta')) {
      context.handle(
        _cafHastaMeta,
        cafHasta.isAcceptableOrUnknown(data['caf_hasta']!, _cafHastaMeta),
      );
    } else if (isInserting) {
      context.missing(_cafHastaMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {storeId, documentType};
  @override
  DteFolioCounterRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DteFolioCounterRow(
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      documentType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}document_type'],
      )!,
      nextFolio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}next_folio'],
      )!,
      cafDesde: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}caf_desde'],
      )!,
      cafHasta: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}caf_hasta'],
      )!,
    );
  }

  @override
  $DteFolioCountersTable createAlias(String alias) {
    return $DteFolioCountersTable(attachedDatabase, alias);
  }
}

class DteFolioCounterRow extends DataClass
    implements Insertable<DteFolioCounterRow> {
  final String storeId;
  final int documentType;
  final int nextFolio;
  final int cafDesde;
  final int cafHasta;
  const DteFolioCounterRow({
    required this.storeId,
    required this.documentType,
    required this.nextFolio,
    required this.cafDesde,
    required this.cafHasta,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['store_id'] = Variable<String>(storeId);
    map['document_type'] = Variable<int>(documentType);
    map['next_folio'] = Variable<int>(nextFolio);
    map['caf_desde'] = Variable<int>(cafDesde);
    map['caf_hasta'] = Variable<int>(cafHasta);
    return map;
  }

  DteFolioCountersCompanion toCompanion(bool nullToAbsent) {
    return DteFolioCountersCompanion(
      storeId: Value(storeId),
      documentType: Value(documentType),
      nextFolio: Value(nextFolio),
      cafDesde: Value(cafDesde),
      cafHasta: Value(cafHasta),
    );
  }

  factory DteFolioCounterRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DteFolioCounterRow(
      storeId: serializer.fromJson<String>(json['storeId']),
      documentType: serializer.fromJson<int>(json['documentType']),
      nextFolio: serializer.fromJson<int>(json['nextFolio']),
      cafDesde: serializer.fromJson<int>(json['cafDesde']),
      cafHasta: serializer.fromJson<int>(json['cafHasta']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'storeId': serializer.toJson<String>(storeId),
      'documentType': serializer.toJson<int>(documentType),
      'nextFolio': serializer.toJson<int>(nextFolio),
      'cafDesde': serializer.toJson<int>(cafDesde),
      'cafHasta': serializer.toJson<int>(cafHasta),
    };
  }

  DteFolioCounterRow copyWith({
    String? storeId,
    int? documentType,
    int? nextFolio,
    int? cafDesde,
    int? cafHasta,
  }) => DteFolioCounterRow(
    storeId: storeId ?? this.storeId,
    documentType: documentType ?? this.documentType,
    nextFolio: nextFolio ?? this.nextFolio,
    cafDesde: cafDesde ?? this.cafDesde,
    cafHasta: cafHasta ?? this.cafHasta,
  );
  DteFolioCounterRow copyWithCompanion(DteFolioCountersCompanion data) {
    return DteFolioCounterRow(
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      documentType: data.documentType.present
          ? data.documentType.value
          : this.documentType,
      nextFolio: data.nextFolio.present ? data.nextFolio.value : this.nextFolio,
      cafDesde: data.cafDesde.present ? data.cafDesde.value : this.cafDesde,
      cafHasta: data.cafHasta.present ? data.cafHasta.value : this.cafHasta,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DteFolioCounterRow(')
          ..write('storeId: $storeId, ')
          ..write('documentType: $documentType, ')
          ..write('nextFolio: $nextFolio, ')
          ..write('cafDesde: $cafDesde, ')
          ..write('cafHasta: $cafHasta')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(storeId, documentType, nextFolio, cafDesde, cafHasta);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DteFolioCounterRow &&
          other.storeId == this.storeId &&
          other.documentType == this.documentType &&
          other.nextFolio == this.nextFolio &&
          other.cafDesde == this.cafDesde &&
          other.cafHasta == this.cafHasta);
}

class DteFolioCountersCompanion extends UpdateCompanion<DteFolioCounterRow> {
  final Value<String> storeId;
  final Value<int> documentType;
  final Value<int> nextFolio;
  final Value<int> cafDesde;
  final Value<int> cafHasta;
  final Value<int> rowid;
  const DteFolioCountersCompanion({
    this.storeId = const Value.absent(),
    this.documentType = const Value.absent(),
    this.nextFolio = const Value.absent(),
    this.cafDesde = const Value.absent(),
    this.cafHasta = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DteFolioCountersCompanion.insert({
    required String storeId,
    required int documentType,
    required int nextFolio,
    required int cafDesde,
    required int cafHasta,
    this.rowid = const Value.absent(),
  }) : storeId = Value(storeId),
       documentType = Value(documentType),
       nextFolio = Value(nextFolio),
       cafDesde = Value(cafDesde),
       cafHasta = Value(cafHasta);
  static Insertable<DteFolioCounterRow> custom({
    Expression<String>? storeId,
    Expression<int>? documentType,
    Expression<int>? nextFolio,
    Expression<int>? cafDesde,
    Expression<int>? cafHasta,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (storeId != null) 'store_id': storeId,
      if (documentType != null) 'document_type': documentType,
      if (nextFolio != null) 'next_folio': nextFolio,
      if (cafDesde != null) 'caf_desde': cafDesde,
      if (cafHasta != null) 'caf_hasta': cafHasta,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DteFolioCountersCompanion copyWith({
    Value<String>? storeId,
    Value<int>? documentType,
    Value<int>? nextFolio,
    Value<int>? cafDesde,
    Value<int>? cafHasta,
    Value<int>? rowid,
  }) {
    return DteFolioCountersCompanion(
      storeId: storeId ?? this.storeId,
      documentType: documentType ?? this.documentType,
      nextFolio: nextFolio ?? this.nextFolio,
      cafDesde: cafDesde ?? this.cafDesde,
      cafHasta: cafHasta ?? this.cafHasta,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (documentType.present) {
      map['document_type'] = Variable<int>(documentType.value);
    }
    if (nextFolio.present) {
      map['next_folio'] = Variable<int>(nextFolio.value);
    }
    if (cafDesde.present) {
      map['caf_desde'] = Variable<int>(cafDesde.value);
    }
    if (cafHasta.present) {
      map['caf_hasta'] = Variable<int>(cafHasta.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DteFolioCountersCompanion(')
          ..write('storeId: $storeId, ')
          ..write('documentType: $documentType, ')
          ..write('nextFolio: $nextFolio, ')
          ..write('cafDesde: $cafDesde, ')
          ..write('cafHasta: $cafHasta, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ClockStateTable extends ClockState
    with TableInfo<$ClockStateTable, ClockStateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ClockStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _offsetMicrosecondsMeta =
      const VerificationMeta('offsetMicroseconds');
  @override
  late final GeneratedColumn<int> offsetMicroseconds = GeneratedColumn<int>(
    'offset_microseconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<String> lastSyncAt = GeneratedColumn<String>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('device'),
  );
  static const VerificationMeta _degradedMeta = const VerificationMeta(
    'degraded',
  );
  @override
  late final GeneratedColumn<bool> degraded = GeneratedColumn<bool>(
    'degraded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("degraded" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    offsetMicroseconds,
    lastSyncAt,
    source,
    degraded,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'clock_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<ClockStateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('offset_microseconds')) {
      context.handle(
        _offsetMicrosecondsMeta,
        offsetMicroseconds.isAcceptableOrUnknown(
          data['offset_microseconds']!,
          _offsetMicrosecondsMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('degraded')) {
      context.handle(
        _degradedMeta,
        degraded.isAcceptableOrUnknown(data['degraded']!, _degradedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ClockStateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ClockStateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      offsetMicroseconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}offset_microseconds'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_sync_at'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      degraded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}degraded'],
      )!,
    );
  }

  @override
  $ClockStateTable createAlias(String alias) {
    return $ClockStateTable(attachedDatabase, alias);
  }
}

class ClockStateRow extends DataClass implements Insertable<ClockStateRow> {
  final String id;
  final int offsetMicroseconds;
  final String? lastSyncAt;
  final String source;
  final bool degraded;
  const ClockStateRow({
    required this.id,
    required this.offsetMicroseconds,
    this.lastSyncAt,
    required this.source,
    required this.degraded,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['offset_microseconds'] = Variable<int>(offsetMicroseconds);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<String>(lastSyncAt);
    }
    map['source'] = Variable<String>(source);
    map['degraded'] = Variable<bool>(degraded);
    return map;
  }

  ClockStateCompanion toCompanion(bool nullToAbsent) {
    return ClockStateCompanion(
      id: Value(id),
      offsetMicroseconds: Value(offsetMicroseconds),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
      source: Value(source),
      degraded: Value(degraded),
    );
  }

  factory ClockStateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ClockStateRow(
      id: serializer.fromJson<String>(json['id']),
      offsetMicroseconds: serializer.fromJson<int>(json['offsetMicroseconds']),
      lastSyncAt: serializer.fromJson<String?>(json['lastSyncAt']),
      source: serializer.fromJson<String>(json['source']),
      degraded: serializer.fromJson<bool>(json['degraded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'offsetMicroseconds': serializer.toJson<int>(offsetMicroseconds),
      'lastSyncAt': serializer.toJson<String?>(lastSyncAt),
      'source': serializer.toJson<String>(source),
      'degraded': serializer.toJson<bool>(degraded),
    };
  }

  ClockStateRow copyWith({
    String? id,
    int? offsetMicroseconds,
    Value<String?> lastSyncAt = const Value.absent(),
    String? source,
    bool? degraded,
  }) => ClockStateRow(
    id: id ?? this.id,
    offsetMicroseconds: offsetMicroseconds ?? this.offsetMicroseconds,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
    source: source ?? this.source,
    degraded: degraded ?? this.degraded,
  );
  ClockStateRow copyWithCompanion(ClockStateCompanion data) {
    return ClockStateRow(
      id: data.id.present ? data.id.value : this.id,
      offsetMicroseconds: data.offsetMicroseconds.present
          ? data.offsetMicroseconds.value
          : this.offsetMicroseconds,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
      source: data.source.present ? data.source.value : this.source,
      degraded: data.degraded.present ? data.degraded.value : this.degraded,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ClockStateRow(')
          ..write('id: $id, ')
          ..write('offsetMicroseconds: $offsetMicroseconds, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('source: $source, ')
          ..write('degraded: $degraded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, offsetMicroseconds, lastSyncAt, source, degraded);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ClockStateRow &&
          other.id == this.id &&
          other.offsetMicroseconds == this.offsetMicroseconds &&
          other.lastSyncAt == this.lastSyncAt &&
          other.source == this.source &&
          other.degraded == this.degraded);
}

class ClockStateCompanion extends UpdateCompanion<ClockStateRow> {
  final Value<String> id;
  final Value<int> offsetMicroseconds;
  final Value<String?> lastSyncAt;
  final Value<String> source;
  final Value<bool> degraded;
  final Value<int> rowid;
  const ClockStateCompanion({
    this.id = const Value.absent(),
    this.offsetMicroseconds = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.source = const Value.absent(),
    this.degraded = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ClockStateCompanion.insert({
    required String id,
    this.offsetMicroseconds = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.source = const Value.absent(),
    this.degraded = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<ClockStateRow> custom({
    Expression<String>? id,
    Expression<int>? offsetMicroseconds,
    Expression<String>? lastSyncAt,
    Expression<String>? source,
    Expression<bool>? degraded,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (offsetMicroseconds != null) 'offset_microseconds': offsetMicroseconds,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (source != null) 'source': source,
      if (degraded != null) 'degraded': degraded,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ClockStateCompanion copyWith({
    Value<String>? id,
    Value<int>? offsetMicroseconds,
    Value<String?>? lastSyncAt,
    Value<String>? source,
    Value<bool>? degraded,
    Value<int>? rowid,
  }) {
    return ClockStateCompanion(
      id: id ?? this.id,
      offsetMicroseconds: offsetMicroseconds ?? this.offsetMicroseconds,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      source: source ?? this.source,
      degraded: degraded ?? this.degraded,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (offsetMicroseconds.present) {
      map['offset_microseconds'] = Variable<int>(offsetMicroseconds.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<String>(lastSyncAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (degraded.present) {
      map['degraded'] = Variable<bool>(degraded.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ClockStateCompanion(')
          ..write('id: $id, ')
          ..write('offsetMicroseconds: $offsetMicroseconds, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('source: $source, ')
          ..write('degraded: $degraded, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $StoresTable stores = $StoresTable(this);
  late final $ProductsTable products = $ProductsTable(this);
  late final $StockMovementsTable stockMovements = $StockMovementsTable(this);
  late final $ShiftsTable shifts = $ShiftsTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $SaleLinesTable saleLines = $SaleLinesTable(this);
  late final $PaymentsTable payments = $PaymentsTable(this);
  late final $DteQueueTable dteQueue = $DteQueueTable(this);
  late final $UsersTable users = $UsersTable(this);
  late final $CollaboratorsTable collaborators = $CollaboratorsTable(this);
  late final $DteFolioCountersTable dteFolioCounters = $DteFolioCountersTable(
    this,
  );
  late final $ClockStateTable clockState = $ClockStateTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    stores,
    products,
    stockMovements,
    shifts,
    sales,
    saleLines,
    payments,
    dteQueue,
    users,
    collaborators,
    dteFolioCounters,
    clockState,
  ];
}

typedef $$StoresTableCreateCompanionBuilder =
    StoresCompanion Function({
      required String id,
      required String rut,
      required String legalName,
      required String businessLine,
      required String taxConfig,
      required String createdAt,
      Value<int> rowid,
    });
typedef $$StoresTableUpdateCompanionBuilder =
    StoresCompanion Function({
      Value<String> id,
      Value<String> rut,
      Value<String> legalName,
      Value<String> businessLine,
      Value<String> taxConfig,
      Value<String> createdAt,
      Value<int> rowid,
    });

class $$StoresTableFilterComposer
    extends Composer<_$AppDatabase, $StoresTable> {
  $$StoresTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rut => $composableBuilder(
    column: $table.rut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get legalName => $composableBuilder(
    column: $table.legalName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessLine => $composableBuilder(
    column: $table.businessLine,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get taxConfig => $composableBuilder(
    column: $table.taxConfig,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StoresTableOrderingComposer
    extends Composer<_$AppDatabase, $StoresTable> {
  $$StoresTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rut => $composableBuilder(
    column: $table.rut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get legalName => $composableBuilder(
    column: $table.legalName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessLine => $composableBuilder(
    column: $table.businessLine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get taxConfig => $composableBuilder(
    column: $table.taxConfig,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoresTable> {
  $$StoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get rut =>
      $composableBuilder(column: $table.rut, builder: (column) => column);

  GeneratedColumn<String> get legalName =>
      $composableBuilder(column: $table.legalName, builder: (column) => column);

  GeneratedColumn<String> get businessLine => $composableBuilder(
    column: $table.businessLine,
    builder: (column) => column,
  );

  GeneratedColumn<String> get taxConfig =>
      $composableBuilder(column: $table.taxConfig, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$StoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoresTable,
          StoreRow,
          $$StoresTableFilterComposer,
          $$StoresTableOrderingComposer,
          $$StoresTableAnnotationComposer,
          $$StoresTableCreateCompanionBuilder,
          $$StoresTableUpdateCompanionBuilder,
          (StoreRow, BaseReferences<_$AppDatabase, $StoresTable, StoreRow>),
          StoreRow,
          PrefetchHooks Function()
        > {
  $$StoresTableTableManager(_$AppDatabase db, $StoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> rut = const Value.absent(),
                Value<String> legalName = const Value.absent(),
                Value<String> businessLine = const Value.absent(),
                Value<String> taxConfig = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoresCompanion(
                id: id,
                rut: rut,
                legalName: legalName,
                businessLine: businessLine,
                taxConfig: taxConfig,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String rut,
                required String legalName,
                required String businessLine,
                required String taxConfig,
                required String createdAt,
                Value<int> rowid = const Value.absent(),
              }) => StoresCompanion.insert(
                id: id,
                rut: rut,
                legalName: legalName,
                businessLine: businessLine,
                taxConfig: taxConfig,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoresTable,
      StoreRow,
      $$StoresTableFilterComposer,
      $$StoresTableOrderingComposer,
      $$StoresTableAnnotationComposer,
      $$StoresTableCreateCompanionBuilder,
      $$StoresTableUpdateCompanionBuilder,
      (StoreRow, BaseReferences<_$AppDatabase, $StoresTable, StoreRow>),
      StoreRow,
      PrefetchHooks Function()
    >;
typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      required String id,
      required String storeId,
      required String name,
      required int salePriceClp,
      Value<int?> costClp,
      Value<String?> barcode,
      Value<String?> qrPayload,
      required int stock,
      required bool blockWhenOutOfStock,
      Value<int> rowid,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<String> id,
      Value<String> storeId,
      Value<String> name,
      Value<int> salePriceClp,
      Value<int?> costClp,
      Value<String?> barcode,
      Value<String?> qrPayload,
      Value<int> stock,
      Value<bool> blockWhenOutOfStock,
      Value<int> rowid,
    });

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get salePriceClp => $composableBuilder(
    column: $table.salePriceClp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costClp => $composableBuilder(
    column: $table.costClp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qrPayload => $composableBuilder(
    column: $table.qrPayload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get blockWhenOutOfStock => $composableBuilder(
    column: $table.blockWhenOutOfStock,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get salePriceClp => $composableBuilder(
    column: $table.salePriceClp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costClp => $composableBuilder(
    column: $table.costClp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get barcode => $composableBuilder(
    column: $table.barcode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qrPayload => $composableBuilder(
    column: $table.qrPayload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get blockWhenOutOfStock => $composableBuilder(
    column: $table.blockWhenOutOfStock,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get salePriceClp => $composableBuilder(
    column: $table.salePriceClp,
    builder: (column) => column,
  );

  GeneratedColumn<int> get costClp =>
      $composableBuilder(column: $table.costClp, builder: (column) => column);

  GeneratedColumn<String> get barcode =>
      $composableBuilder(column: $table.barcode, builder: (column) => column);

  GeneratedColumn<String> get qrPayload =>
      $composableBuilder(column: $table.qrPayload, builder: (column) => column);

  GeneratedColumn<int> get stock =>
      $composableBuilder(column: $table.stock, builder: (column) => column);

  GeneratedColumn<bool> get blockWhenOutOfStock => $composableBuilder(
    column: $table.blockWhenOutOfStock,
    builder: (column) => column,
  );
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          ProductRow,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (
            ProductRow,
            BaseReferences<_$AppDatabase, $ProductsTable, ProductRow>,
          ),
          ProductRow,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> salePriceClp = const Value.absent(),
                Value<int?> costClp = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> qrPayload = const Value.absent(),
                Value<int> stock = const Value.absent(),
                Value<bool> blockWhenOutOfStock = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                storeId: storeId,
                name: name,
                salePriceClp: salePriceClp,
                costClp: costClp,
                barcode: barcode,
                qrPayload: qrPayload,
                stock: stock,
                blockWhenOutOfStock: blockWhenOutOfStock,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required String name,
                required int salePriceClp,
                Value<int?> costClp = const Value.absent(),
                Value<String?> barcode = const Value.absent(),
                Value<String?> qrPayload = const Value.absent(),
                required int stock,
                required bool blockWhenOutOfStock,
                Value<int> rowid = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                storeId: storeId,
                name: name,
                salePriceClp: salePriceClp,
                costClp: costClp,
                barcode: barcode,
                qrPayload: qrPayload,
                stock: stock,
                blockWhenOutOfStock: blockWhenOutOfStock,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      ProductRow,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (ProductRow, BaseReferences<_$AppDatabase, $ProductsTable, ProductRow>),
      ProductRow,
      PrefetchHooks Function()
    >;
typedef $$StockMovementsTableCreateCompanionBuilder =
    StockMovementsCompanion Function({
      required String id,
      required String storeId,
      required String productId,
      required int delta,
      required String reason,
      Value<String?> note,
      Value<String?> actorId,
      required String createdAt,
      Value<int> rowid,
    });
typedef $$StockMovementsTableUpdateCompanionBuilder =
    StockMovementsCompanion Function({
      Value<String> id,
      Value<String> storeId,
      Value<String> productId,
      Value<int> delta,
      Value<String> reason,
      Value<String?> note,
      Value<String?> actorId,
      Value<String> createdAt,
      Value<int> rowid,
    });

class $$StockMovementsTableFilterComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get delta => $composableBuilder(
    column: $table.delta,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actorId => $composableBuilder(
    column: $table.actorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StockMovementsTableOrderingComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get delta => $composableBuilder(
    column: $table.delta,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actorId => $composableBuilder(
    column: $table.actorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StockMovementsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StockMovementsTable> {
  $$StockMovementsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get delta =>
      $composableBuilder(column: $table.delta, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get actorId =>
      $composableBuilder(column: $table.actorId, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$StockMovementsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StockMovementsTable,
          StockMovementRow,
          $$StockMovementsTableFilterComposer,
          $$StockMovementsTableOrderingComposer,
          $$StockMovementsTableAnnotationComposer,
          $$StockMovementsTableCreateCompanionBuilder,
          $$StockMovementsTableUpdateCompanionBuilder,
          (
            StockMovementRow,
            BaseReferences<
              _$AppDatabase,
              $StockMovementsTable,
              StockMovementRow
            >,
          ),
          StockMovementRow,
          PrefetchHooks Function()
        > {
  $$StockMovementsTableTableManager(
    _$AppDatabase db,
    $StockMovementsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StockMovementsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StockMovementsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StockMovementsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int> delta = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String?> actorId = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StockMovementsCompanion(
                id: id,
                storeId: storeId,
                productId: productId,
                delta: delta,
                reason: reason,
                note: note,
                actorId: actorId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required String productId,
                required int delta,
                required String reason,
                Value<String?> note = const Value.absent(),
                Value<String?> actorId = const Value.absent(),
                required String createdAt,
                Value<int> rowid = const Value.absent(),
              }) => StockMovementsCompanion.insert(
                id: id,
                storeId: storeId,
                productId: productId,
                delta: delta,
                reason: reason,
                note: note,
                actorId: actorId,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StockMovementsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StockMovementsTable,
      StockMovementRow,
      $$StockMovementsTableFilterComposer,
      $$StockMovementsTableOrderingComposer,
      $$StockMovementsTableAnnotationComposer,
      $$StockMovementsTableCreateCompanionBuilder,
      $$StockMovementsTableUpdateCompanionBuilder,
      (
        StockMovementRow,
        BaseReferences<_$AppDatabase, $StockMovementsTable, StockMovementRow>,
      ),
      StockMovementRow,
      PrefetchHooks Function()
    >;
typedef $$ShiftsTableCreateCompanionBuilder =
    ShiftsCompanion Function({
      required String id,
      required String storeId,
      required int openingCashClp,
      Value<int?> countedCashClp,
      required String status,
      required String openedAt,
      Value<String?> closedAt,
      Value<int> rowid,
    });
typedef $$ShiftsTableUpdateCompanionBuilder =
    ShiftsCompanion Function({
      Value<String> id,
      Value<String> storeId,
      Value<int> openingCashClp,
      Value<int?> countedCashClp,
      Value<String> status,
      Value<String> openedAt,
      Value<String?> closedAt,
      Value<int> rowid,
    });

class $$ShiftsTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get openingCashClp => $composableBuilder(
    column: $table.openingCashClp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get countedCashClp => $composableBuilder(
    column: $table.countedCashClp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShiftsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get openingCashClp => $composableBuilder(
    column: $table.openingCashClp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get countedCashClp => $composableBuilder(
    column: $table.countedCashClp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get openedAt => $composableBuilder(
    column: $table.openedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get closedAt => $composableBuilder(
    column: $table.closedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShiftsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftsTable> {
  $$ShiftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<int> get openingCashClp => $composableBuilder(
    column: $table.openingCashClp,
    builder: (column) => column,
  );

  GeneratedColumn<int> get countedCashClp => $composableBuilder(
    column: $table.countedCashClp,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get openedAt =>
      $composableBuilder(column: $table.openedAt, builder: (column) => column);

  GeneratedColumn<String> get closedAt =>
      $composableBuilder(column: $table.closedAt, builder: (column) => column);
}

class $$ShiftsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftsTable,
          ShiftRow,
          $$ShiftsTableFilterComposer,
          $$ShiftsTableOrderingComposer,
          $$ShiftsTableAnnotationComposer,
          $$ShiftsTableCreateCompanionBuilder,
          $$ShiftsTableUpdateCompanionBuilder,
          (ShiftRow, BaseReferences<_$AppDatabase, $ShiftsTable, ShiftRow>),
          ShiftRow,
          PrefetchHooks Function()
        > {
  $$ShiftsTableTableManager(_$AppDatabase db, $ShiftsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<int> openingCashClp = const Value.absent(),
                Value<int?> countedCashClp = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> openedAt = const Value.absent(),
                Value<String?> closedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftsCompanion(
                id: id,
                storeId: storeId,
                openingCashClp: openingCashClp,
                countedCashClp: countedCashClp,
                status: status,
                openedAt: openedAt,
                closedAt: closedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required int openingCashClp,
                Value<int?> countedCashClp = const Value.absent(),
                required String status,
                required String openedAt,
                Value<String?> closedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShiftsCompanion.insert(
                id: id,
                storeId: storeId,
                openingCashClp: openingCashClp,
                countedCashClp: countedCashClp,
                status: status,
                openedAt: openedAt,
                closedAt: closedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShiftsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftsTable,
      ShiftRow,
      $$ShiftsTableFilterComposer,
      $$ShiftsTableOrderingComposer,
      $$ShiftsTableAnnotationComposer,
      $$ShiftsTableCreateCompanionBuilder,
      $$ShiftsTableUpdateCompanionBuilder,
      (ShiftRow, BaseReferences<_$AppDatabase, $ShiftsTable, ShiftRow>),
      ShiftRow,
      PrefetchHooks Function()
    >;
typedef $$SalesTableCreateCompanionBuilder =
    SalesCompanion Function({
      required String id,
      required String storeId,
      required String shiftId,
      required String cartId,
      required int totalClp,
      required int changeClp,
      required String createdAt,
      Value<String> status,
      Value<String> dteStatus,
      Value<int?> folio,
      Value<String?> pdfUrl,
      Value<String?> confirmedByUserId,
      Value<int> rowid,
    });
typedef $$SalesTableUpdateCompanionBuilder =
    SalesCompanion Function({
      Value<String> id,
      Value<String> storeId,
      Value<String> shiftId,
      Value<String> cartId,
      Value<int> totalClp,
      Value<int> changeClp,
      Value<String> createdAt,
      Value<String> status,
      Value<String> dteStatus,
      Value<int?> folio,
      Value<String?> pdfUrl,
      Value<String?> confirmedByUserId,
      Value<int> rowid,
    });

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cartId => $composableBuilder(
    column: $table.cartId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalClp => $composableBuilder(
    column: $table.totalClp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get changeClp => $composableBuilder(
    column: $table.changeClp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dteStatus => $composableBuilder(
    column: $table.dteStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get folio => $composableBuilder(
    column: $table.folio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pdfUrl => $composableBuilder(
    column: $table.pdfUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get confirmedByUserId => $composableBuilder(
    column: $table.confirmedByUserId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cartId => $composableBuilder(
    column: $table.cartId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalClp => $composableBuilder(
    column: $table.totalClp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get changeClp => $composableBuilder(
    column: $table.changeClp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dteStatus => $composableBuilder(
    column: $table.dteStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get folio => $composableBuilder(
    column: $table.folio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pdfUrl => $composableBuilder(
    column: $table.pdfUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get confirmedByUserId => $composableBuilder(
    column: $table.confirmedByUserId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get shiftId =>
      $composableBuilder(column: $table.shiftId, builder: (column) => column);

  GeneratedColumn<String> get cartId =>
      $composableBuilder(column: $table.cartId, builder: (column) => column);

  GeneratedColumn<int> get totalClp =>
      $composableBuilder(column: $table.totalClp, builder: (column) => column);

  GeneratedColumn<int> get changeClp =>
      $composableBuilder(column: $table.changeClp, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get dteStatus =>
      $composableBuilder(column: $table.dteStatus, builder: (column) => column);

  GeneratedColumn<int> get folio =>
      $composableBuilder(column: $table.folio, builder: (column) => column);

  GeneratedColumn<String> get pdfUrl =>
      $composableBuilder(column: $table.pdfUrl, builder: (column) => column);

  GeneratedColumn<String> get confirmedByUserId => $composableBuilder(
    column: $table.confirmedByUserId,
    builder: (column) => column,
  );
}

class $$SalesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalesTable,
          SaleRow,
          $$SalesTableFilterComposer,
          $$SalesTableOrderingComposer,
          $$SalesTableAnnotationComposer,
          $$SalesTableCreateCompanionBuilder,
          $$SalesTableUpdateCompanionBuilder,
          (SaleRow, BaseReferences<_$AppDatabase, $SalesTable, SaleRow>),
          SaleRow,
          PrefetchHooks Function()
        > {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<String> shiftId = const Value.absent(),
                Value<String> cartId = const Value.absent(),
                Value<int> totalClp = const Value.absent(),
                Value<int> changeClp = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> dteStatus = const Value.absent(),
                Value<int?> folio = const Value.absent(),
                Value<String?> pdfUrl = const Value.absent(),
                Value<String?> confirmedByUserId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesCompanion(
                id: id,
                storeId: storeId,
                shiftId: shiftId,
                cartId: cartId,
                totalClp: totalClp,
                changeClp: changeClp,
                createdAt: createdAt,
                status: status,
                dteStatus: dteStatus,
                folio: folio,
                pdfUrl: pdfUrl,
                confirmedByUserId: confirmedByUserId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required String shiftId,
                required String cartId,
                required int totalClp,
                required int changeClp,
                required String createdAt,
                Value<String> status = const Value.absent(),
                Value<String> dteStatus = const Value.absent(),
                Value<int?> folio = const Value.absent(),
                Value<String?> pdfUrl = const Value.absent(),
                Value<String?> confirmedByUserId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SalesCompanion.insert(
                id: id,
                storeId: storeId,
                shiftId: shiftId,
                cartId: cartId,
                totalClp: totalClp,
                changeClp: changeClp,
                createdAt: createdAt,
                status: status,
                dteStatus: dteStatus,
                folio: folio,
                pdfUrl: pdfUrl,
                confirmedByUserId: confirmedByUserId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SalesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalesTable,
      SaleRow,
      $$SalesTableFilterComposer,
      $$SalesTableOrderingComposer,
      $$SalesTableAnnotationComposer,
      $$SalesTableCreateCompanionBuilder,
      $$SalesTableUpdateCompanionBuilder,
      (SaleRow, BaseReferences<_$AppDatabase, $SalesTable, SaleRow>),
      SaleRow,
      PrefetchHooks Function()
    >;
typedef $$SaleLinesTableCreateCompanionBuilder =
    SaleLinesCompanion Function({
      required String id,
      required String saleId,
      required String productId,
      required String productName,
      required int quantity,
      required int unitPriceClp,
      Value<int> rowid,
    });
typedef $$SaleLinesTableUpdateCompanionBuilder =
    SaleLinesCompanion Function({
      Value<String> id,
      Value<String> saleId,
      Value<String> productId,
      Value<String> productName,
      Value<int> quantity,
      Value<int> unitPriceClp,
      Value<int> rowid,
    });

class $$SaleLinesTableFilterComposer
    extends Composer<_$AppDatabase, $SaleLinesTable> {
  $$SaleLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitPriceClp => $composableBuilder(
    column: $table.unitPriceClp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SaleLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $SaleLinesTable> {
  $$SaleLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitPriceClp => $composableBuilder(
    column: $table.unitPriceClp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SaleLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SaleLinesTable> {
  $$SaleLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<String> get productName => $composableBuilder(
    column: $table.productName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<int> get unitPriceClp => $composableBuilder(
    column: $table.unitPriceClp,
    builder: (column) => column,
  );
}

class $$SaleLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SaleLinesTable,
          SaleLineRow,
          $$SaleLinesTableFilterComposer,
          $$SaleLinesTableOrderingComposer,
          $$SaleLinesTableAnnotationComposer,
          $$SaleLinesTableCreateCompanionBuilder,
          $$SaleLinesTableUpdateCompanionBuilder,
          (
            SaleLineRow,
            BaseReferences<_$AppDatabase, $SaleLinesTable, SaleLineRow>,
          ),
          SaleLineRow,
          PrefetchHooks Function()
        > {
  $$SaleLinesTableTableManager(_$AppDatabase db, $SaleLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SaleLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SaleLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SaleLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> saleId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> unitPriceClp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SaleLinesCompanion(
                id: id,
                saleId: saleId,
                productId: productId,
                productName: productName,
                quantity: quantity,
                unitPriceClp: unitPriceClp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String saleId,
                required String productId,
                required String productName,
                required int quantity,
                required int unitPriceClp,
                Value<int> rowid = const Value.absent(),
              }) => SaleLinesCompanion.insert(
                id: id,
                saleId: saleId,
                productId: productId,
                productName: productName,
                quantity: quantity,
                unitPriceClp: unitPriceClp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SaleLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SaleLinesTable,
      SaleLineRow,
      $$SaleLinesTableFilterComposer,
      $$SaleLinesTableOrderingComposer,
      $$SaleLinesTableAnnotationComposer,
      $$SaleLinesTableCreateCompanionBuilder,
      $$SaleLinesTableUpdateCompanionBuilder,
      (
        SaleLineRow,
        BaseReferences<_$AppDatabase, $SaleLinesTable, SaleLineRow>,
      ),
      SaleLineRow,
      PrefetchHooks Function()
    >;
typedef $$PaymentsTableCreateCompanionBuilder =
    PaymentsCompanion Function({
      required String id,
      required String saleId,
      required String method,
      required int amountClp,
      Value<int> rowid,
    });
typedef $$PaymentsTableUpdateCompanionBuilder =
    PaymentsCompanion Function({
      Value<String> id,
      Value<String> saleId,
      Value<String> method,
      Value<int> amountClp,
      Value<int> rowid,
    });

class $$PaymentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountClp => $composableBuilder(
    column: $table.amountClp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountClp => $composableBuilder(
    column: $table.amountClp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentsTable> {
  $$PaymentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<int> get amountClp =>
      $composableBuilder(column: $table.amountClp, builder: (column) => column);
}

class $$PaymentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentsTable,
          PaymentRow,
          $$PaymentsTableFilterComposer,
          $$PaymentsTableOrderingComposer,
          $$PaymentsTableAnnotationComposer,
          $$PaymentsTableCreateCompanionBuilder,
          $$PaymentsTableUpdateCompanionBuilder,
          (
            PaymentRow,
            BaseReferences<_$AppDatabase, $PaymentsTable, PaymentRow>,
          ),
          PaymentRow,
          PrefetchHooks Function()
        > {
  $$PaymentsTableTableManager(_$AppDatabase db, $PaymentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> saleId = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<int> amountClp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentsCompanion(
                id: id,
                saleId: saleId,
                method: method,
                amountClp: amountClp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String saleId,
                required String method,
                required int amountClp,
                Value<int> rowid = const Value.absent(),
              }) => PaymentsCompanion.insert(
                id: id,
                saleId: saleId,
                method: method,
                amountClp: amountClp,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentsTable,
      PaymentRow,
      $$PaymentsTableFilterComposer,
      $$PaymentsTableOrderingComposer,
      $$PaymentsTableAnnotationComposer,
      $$PaymentsTableCreateCompanionBuilder,
      $$PaymentsTableUpdateCompanionBuilder,
      (PaymentRow, BaseReferences<_$AppDatabase, $PaymentsTable, PaymentRow>),
      PaymentRow,
      PrefetchHooks Function()
    >;
typedef $$DteQueueTableCreateCompanionBuilder =
    DteQueueCompanion Function({
      required String saleId,
      required String storeId,
      Value<int> attempts,
      Value<String?> lastError,
      required String createdAt,
      Value<int> rowid,
    });
typedef $$DteQueueTableUpdateCompanionBuilder =
    DteQueueCompanion Function({
      Value<String> saleId,
      Value<String> storeId,
      Value<int> attempts,
      Value<String?> lastError,
      Value<String> createdAt,
      Value<int> rowid,
    });

class $$DteQueueTableFilterComposer
    extends Composer<_$AppDatabase, $DteQueueTable> {
  $$DteQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DteQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $DteQueueTable> {
  $$DteQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DteQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $DteQueueTable> {
  $$DteQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DteQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DteQueueTable,
          DteQueueRow,
          $$DteQueueTableFilterComposer,
          $$DteQueueTableOrderingComposer,
          $$DteQueueTableAnnotationComposer,
          $$DteQueueTableCreateCompanionBuilder,
          $$DteQueueTableUpdateCompanionBuilder,
          (
            DteQueueRow,
            BaseReferences<_$AppDatabase, $DteQueueTable, DteQueueRow>,
          ),
          DteQueueRow,
          PrefetchHooks Function()
        > {
  $$DteQueueTableTableManager(_$AppDatabase db, $DteQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DteQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DteQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DteQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> saleId = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DteQueueCompanion(
                saleId: saleId,
                storeId: storeId,
                attempts: attempts,
                lastError: lastError,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String saleId,
                required String storeId,
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required String createdAt,
                Value<int> rowid = const Value.absent(),
              }) => DteQueueCompanion.insert(
                saleId: saleId,
                storeId: storeId,
                attempts: attempts,
                lastError: lastError,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DteQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DteQueueTable,
      DteQueueRow,
      $$DteQueueTableFilterComposer,
      $$DteQueueTableOrderingComposer,
      $$DteQueueTableAnnotationComposer,
      $$DteQueueTableCreateCompanionBuilder,
      $$DteQueueTableUpdateCompanionBuilder,
      (DteQueueRow, BaseReferences<_$AppDatabase, $DteQueueTable, DteQueueRow>),
      DteQueueRow,
      PrefetchHooks Function()
    >;
typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      required String storeId,
      required String role,
      required String pinHash,
      required String displayName,
      required String username,
      required String firstName,
      required String lastName,
      required String userRut,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> storeId,
      Value<String> role,
      Value<String> pinHash,
      Value<String> displayName,
      Value<String> username,
      Value<String> firstName,
      Value<String> lastName,
      Value<String> userRut,
      Value<int> rowid,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userRut => $composableBuilder(
    column: $table.userRut,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pinHash => $composableBuilder(
    column: $table.pinHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userRut => $composableBuilder(
    column: $table.userRut,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get pinHash =>
      $composableBuilder(column: $table.pinHash, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get userRut =>
      $composableBuilder(column: $table.userRut, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          UserRow,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (UserRow, BaseReferences<_$AppDatabase, $UsersTable, UserRow>),
          UserRow,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> pinHash = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String> userRut = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                storeId: storeId,
                role: role,
                pinHash: pinHash,
                displayName: displayName,
                username: username,
                firstName: firstName,
                lastName: lastName,
                userRut: userRut,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required String role,
                required String pinHash,
                required String displayName,
                required String username,
                required String firstName,
                required String lastName,
                required String userRut,
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                storeId: storeId,
                role: role,
                pinHash: pinHash,
                displayName: displayName,
                username: username,
                firstName: firstName,
                lastName: lastName,
                userRut: userRut,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      UserRow,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (UserRow, BaseReferences<_$AppDatabase, $UsersTable, UserRow>),
      UserRow,
      PrefetchHooks Function()
    >;
typedef $$CollaboratorsTableCreateCompanionBuilder =
    CollaboratorsCompanion Function({
      required String id,
      required String storeId,
      required String sellerCode,
      required String firstName,
      required String lastName,
      Value<bool> active,
      Value<int> rowid,
    });
typedef $$CollaboratorsTableUpdateCompanionBuilder =
    CollaboratorsCompanion Function({
      Value<String> id,
      Value<String> storeId,
      Value<String> sellerCode,
      Value<String> firstName,
      Value<String> lastName,
      Value<bool> active,
      Value<int> rowid,
    });

class $$CollaboratorsTableFilterComposer
    extends Composer<_$AppDatabase, $CollaboratorsTable> {
  $$CollaboratorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sellerCode => $composableBuilder(
    column: $table.sellerCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CollaboratorsTableOrderingComposer
    extends Composer<_$AppDatabase, $CollaboratorsTable> {
  $$CollaboratorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sellerCode => $composableBuilder(
    column: $table.sellerCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CollaboratorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CollaboratorsTable> {
  $$CollaboratorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get sellerCode => $composableBuilder(
    column: $table.sellerCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$CollaboratorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CollaboratorsTable,
          CollaboratorRow,
          $$CollaboratorsTableFilterComposer,
          $$CollaboratorsTableOrderingComposer,
          $$CollaboratorsTableAnnotationComposer,
          $$CollaboratorsTableCreateCompanionBuilder,
          $$CollaboratorsTableUpdateCompanionBuilder,
          (
            CollaboratorRow,
            BaseReferences<_$AppDatabase, $CollaboratorsTable, CollaboratorRow>,
          ),
          CollaboratorRow,
          PrefetchHooks Function()
        > {
  $$CollaboratorsTableTableManager(_$AppDatabase db, $CollaboratorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollaboratorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CollaboratorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CollaboratorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<String> sellerCode = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CollaboratorsCompanion(
                id: id,
                storeId: storeId,
                sellerCode: sellerCode,
                firstName: firstName,
                lastName: lastName,
                active: active,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required String sellerCode,
                required String firstName,
                required String lastName,
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CollaboratorsCompanion.insert(
                id: id,
                storeId: storeId,
                sellerCode: sellerCode,
                firstName: firstName,
                lastName: lastName,
                active: active,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CollaboratorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CollaboratorsTable,
      CollaboratorRow,
      $$CollaboratorsTableFilterComposer,
      $$CollaboratorsTableOrderingComposer,
      $$CollaboratorsTableAnnotationComposer,
      $$CollaboratorsTableCreateCompanionBuilder,
      $$CollaboratorsTableUpdateCompanionBuilder,
      (
        CollaboratorRow,
        BaseReferences<_$AppDatabase, $CollaboratorsTable, CollaboratorRow>,
      ),
      CollaboratorRow,
      PrefetchHooks Function()
    >;
typedef $$DteFolioCountersTableCreateCompanionBuilder =
    DteFolioCountersCompanion Function({
      required String storeId,
      required int documentType,
      required int nextFolio,
      required int cafDesde,
      required int cafHasta,
      Value<int> rowid,
    });
typedef $$DteFolioCountersTableUpdateCompanionBuilder =
    DteFolioCountersCompanion Function({
      Value<String> storeId,
      Value<int> documentType,
      Value<int> nextFolio,
      Value<int> cafDesde,
      Value<int> cafHasta,
      Value<int> rowid,
    });

class $$DteFolioCountersTableFilterComposer
    extends Composer<_$AppDatabase, $DteFolioCountersTable> {
  $$DteFolioCountersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get documentType => $composableBuilder(
    column: $table.documentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get nextFolio => $composableBuilder(
    column: $table.nextFolio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cafDesde => $composableBuilder(
    column: $table.cafDesde,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cafHasta => $composableBuilder(
    column: $table.cafHasta,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DteFolioCountersTableOrderingComposer
    extends Composer<_$AppDatabase, $DteFolioCountersTable> {
  $$DteFolioCountersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get documentType => $composableBuilder(
    column: $table.documentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get nextFolio => $composableBuilder(
    column: $table.nextFolio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cafDesde => $composableBuilder(
    column: $table.cafDesde,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cafHasta => $composableBuilder(
    column: $table.cafHasta,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DteFolioCountersTableAnnotationComposer
    extends Composer<_$AppDatabase, $DteFolioCountersTable> {
  $$DteFolioCountersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<int> get documentType => $composableBuilder(
    column: $table.documentType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get nextFolio =>
      $composableBuilder(column: $table.nextFolio, builder: (column) => column);

  GeneratedColumn<int> get cafDesde =>
      $composableBuilder(column: $table.cafDesde, builder: (column) => column);

  GeneratedColumn<int> get cafHasta =>
      $composableBuilder(column: $table.cafHasta, builder: (column) => column);
}

class $$DteFolioCountersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DteFolioCountersTable,
          DteFolioCounterRow,
          $$DteFolioCountersTableFilterComposer,
          $$DteFolioCountersTableOrderingComposer,
          $$DteFolioCountersTableAnnotationComposer,
          $$DteFolioCountersTableCreateCompanionBuilder,
          $$DteFolioCountersTableUpdateCompanionBuilder,
          (
            DteFolioCounterRow,
            BaseReferences<
              _$AppDatabase,
              $DteFolioCountersTable,
              DteFolioCounterRow
            >,
          ),
          DteFolioCounterRow,
          PrefetchHooks Function()
        > {
  $$DteFolioCountersTableTableManager(
    _$AppDatabase db,
    $DteFolioCountersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DteFolioCountersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DteFolioCountersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DteFolioCountersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> storeId = const Value.absent(),
                Value<int> documentType = const Value.absent(),
                Value<int> nextFolio = const Value.absent(),
                Value<int> cafDesde = const Value.absent(),
                Value<int> cafHasta = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DteFolioCountersCompanion(
                storeId: storeId,
                documentType: documentType,
                nextFolio: nextFolio,
                cafDesde: cafDesde,
                cafHasta: cafHasta,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String storeId,
                required int documentType,
                required int nextFolio,
                required int cafDesde,
                required int cafHasta,
                Value<int> rowid = const Value.absent(),
              }) => DteFolioCountersCompanion.insert(
                storeId: storeId,
                documentType: documentType,
                nextFolio: nextFolio,
                cafDesde: cafDesde,
                cafHasta: cafHasta,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DteFolioCountersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DteFolioCountersTable,
      DteFolioCounterRow,
      $$DteFolioCountersTableFilterComposer,
      $$DteFolioCountersTableOrderingComposer,
      $$DteFolioCountersTableAnnotationComposer,
      $$DteFolioCountersTableCreateCompanionBuilder,
      $$DteFolioCountersTableUpdateCompanionBuilder,
      (
        DteFolioCounterRow,
        BaseReferences<
          _$AppDatabase,
          $DteFolioCountersTable,
          DteFolioCounterRow
        >,
      ),
      DteFolioCounterRow,
      PrefetchHooks Function()
    >;
typedef $$ClockStateTableCreateCompanionBuilder =
    ClockStateCompanion Function({
      required String id,
      Value<int> offsetMicroseconds,
      Value<String?> lastSyncAt,
      Value<String> source,
      Value<bool> degraded,
      Value<int> rowid,
    });
typedef $$ClockStateTableUpdateCompanionBuilder =
    ClockStateCompanion Function({
      Value<String> id,
      Value<int> offsetMicroseconds,
      Value<String?> lastSyncAt,
      Value<String> source,
      Value<bool> degraded,
      Value<int> rowid,
    });

class $$ClockStateTableFilterComposer
    extends Composer<_$AppDatabase, $ClockStateTable> {
  $$ClockStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get offsetMicroseconds => $composableBuilder(
    column: $table.offsetMicroseconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get degraded => $composableBuilder(
    column: $table.degraded,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ClockStateTableOrderingComposer
    extends Composer<_$AppDatabase, $ClockStateTable> {
  $$ClockStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get offsetMicroseconds => $composableBuilder(
    column: $table.offsetMicroseconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get degraded => $composableBuilder(
    column: $table.degraded,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ClockStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $ClockStateTable> {
  $$ClockStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get offsetMicroseconds => $composableBuilder(
    column: $table.offsetMicroseconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get degraded =>
      $composableBuilder(column: $table.degraded, builder: (column) => column);
}

class $$ClockStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ClockStateTable,
          ClockStateRow,
          $$ClockStateTableFilterComposer,
          $$ClockStateTableOrderingComposer,
          $$ClockStateTableAnnotationComposer,
          $$ClockStateTableCreateCompanionBuilder,
          $$ClockStateTableUpdateCompanionBuilder,
          (
            ClockStateRow,
            BaseReferences<_$AppDatabase, $ClockStateTable, ClockStateRow>,
          ),
          ClockStateRow,
          PrefetchHooks Function()
        > {
  $$ClockStateTableTableManager(_$AppDatabase db, $ClockStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ClockStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ClockStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ClockStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> offsetMicroseconds = const Value.absent(),
                Value<String?> lastSyncAt = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<bool> degraded = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClockStateCompanion(
                id: id,
                offsetMicroseconds: offsetMicroseconds,
                lastSyncAt: lastSyncAt,
                source: source,
                degraded: degraded,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<int> offsetMicroseconds = const Value.absent(),
                Value<String?> lastSyncAt = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<bool> degraded = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ClockStateCompanion.insert(
                id: id,
                offsetMicroseconds: offsetMicroseconds,
                lastSyncAt: lastSyncAt,
                source: source,
                degraded: degraded,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ClockStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ClockStateTable,
      ClockStateRow,
      $$ClockStateTableFilterComposer,
      $$ClockStateTableOrderingComposer,
      $$ClockStateTableAnnotationComposer,
      $$ClockStateTableCreateCompanionBuilder,
      $$ClockStateTableUpdateCompanionBuilder,
      (
        ClockStateRow,
        BaseReferences<_$AppDatabase, $ClockStateTable, ClockStateRow>,
      ),
      ClockStateRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$StoresTableTableManager get stores =>
      $$StoresTableTableManager(_db, _db.stores);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
  $$StockMovementsTableTableManager get stockMovements =>
      $$StockMovementsTableTableManager(_db, _db.stockMovements);
  $$ShiftsTableTableManager get shifts =>
      $$ShiftsTableTableManager(_db, _db.shifts);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$SaleLinesTableTableManager get saleLines =>
      $$SaleLinesTableTableManager(_db, _db.saleLines);
  $$PaymentsTableTableManager get payments =>
      $$PaymentsTableTableManager(_db, _db.payments);
  $$DteQueueTableTableManager get dteQueue =>
      $$DteQueueTableTableManager(_db, _db.dteQueue);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$CollaboratorsTableTableManager get collaborators =>
      $$CollaboratorsTableTableManager(_db, _db.collaborators);
  $$DteFolioCountersTableTableManager get dteFolioCounters =>
      $$DteFolioCountersTableTableManager(_db, _db.dteFolioCounters);
  $$ClockStateTableTableManager get clockState =>
      $$ClockStateTableTableManager(_db, _db.clockState);
}
