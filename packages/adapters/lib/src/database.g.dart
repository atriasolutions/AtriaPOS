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
  static const VerificationMeta _posTemplateIdMeta = const VerificationMeta(
    'posTemplateId',
  );
  @override
  late final GeneratedColumn<String> posTemplateId = GeneratedColumn<String>(
    'pos_template_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ATRIA_POS'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    rut,
    legalName,
    businessLine,
    taxConfig,
    createdAt,
    posTemplateId,
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
    if (data.containsKey('pos_template_id')) {
      context.handle(
        _posTemplateIdMeta,
        posTemplateId.isAcceptableOrUnknown(
          data['pos_template_id']!,
          _posTemplateIdMeta,
        ),
      );
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
      posTemplateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pos_template_id'],
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
  final String posTemplateId;
  const StoreRow({
    required this.id,
    required this.rut,
    required this.legalName,
    required this.businessLine,
    required this.taxConfig,
    required this.createdAt,
    required this.posTemplateId,
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
    map['pos_template_id'] = Variable<String>(posTemplateId);
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
      posTemplateId: Value(posTemplateId),
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
      posTemplateId: serializer.fromJson<String>(json['posTemplateId']),
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
      'posTemplateId': serializer.toJson<String>(posTemplateId),
    };
  }

  StoreRow copyWith({
    String? id,
    String? rut,
    String? legalName,
    String? businessLine,
    String? taxConfig,
    String? createdAt,
    String? posTemplateId,
  }) => StoreRow(
    id: id ?? this.id,
    rut: rut ?? this.rut,
    legalName: legalName ?? this.legalName,
    businessLine: businessLine ?? this.businessLine,
    taxConfig: taxConfig ?? this.taxConfig,
    createdAt: createdAt ?? this.createdAt,
    posTemplateId: posTemplateId ?? this.posTemplateId,
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
      posTemplateId: data.posTemplateId.present
          ? data.posTemplateId.value
          : this.posTemplateId,
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
          ..write('createdAt: $createdAt, ')
          ..write('posTemplateId: $posTemplateId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    rut,
    legalName,
    businessLine,
    taxConfig,
    createdAt,
    posTemplateId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoreRow &&
          other.id == this.id &&
          other.rut == this.rut &&
          other.legalName == this.legalName &&
          other.businessLine == this.businessLine &&
          other.taxConfig == this.taxConfig &&
          other.createdAt == this.createdAt &&
          other.posTemplateId == this.posTemplateId);
}

class StoresCompanion extends UpdateCompanion<StoreRow> {
  final Value<String> id;
  final Value<String> rut;
  final Value<String> legalName;
  final Value<String> businessLine;
  final Value<String> taxConfig;
  final Value<String> createdAt;
  final Value<String> posTemplateId;
  final Value<int> rowid;
  const StoresCompanion({
    this.id = const Value.absent(),
    this.rut = const Value.absent(),
    this.legalName = const Value.absent(),
    this.businessLine = const Value.absent(),
    this.taxConfig = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.posTemplateId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoresCompanion.insert({
    required String id,
    required String rut,
    required String legalName,
    required String businessLine,
    required String taxConfig,
    required String createdAt,
    this.posTemplateId = const Value.absent(),
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
    Expression<String>? posTemplateId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (rut != null) 'rut': rut,
      if (legalName != null) 'legal_name': legalName,
      if (businessLine != null) 'business_line': businessLine,
      if (taxConfig != null) 'tax_config': taxConfig,
      if (createdAt != null) 'created_at': createdAt,
      if (posTemplateId != null) 'pos_template_id': posTemplateId,
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
    Value<String>? posTemplateId,
    Value<int>? rowid,
  }) {
    return StoresCompanion(
      id: id ?? this.id,
      rut: rut ?? this.rut,
      legalName: legalName ?? this.legalName,
      businessLine: businessLine ?? this.businessLine,
      taxConfig: taxConfig ?? this.taxConfig,
      createdAt: createdAt ?? this.createdAt,
      posTemplateId: posTemplateId ?? this.posTemplateId,
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
    if (posTemplateId.present) {
      map['pos_template_id'] = Variable<String>(posTemplateId.value);
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
          ..write('posTemplateId: $posTemplateId, ')
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
  static const VerificationMeta _lowStockThresholdMeta = const VerificationMeta(
    'lowStockThreshold',
  );
  @override
  late final GeneratedColumn<int> lowStockThreshold = GeneratedColumn<int>(
    'low_stock_threshold',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
    lowStockThreshold,
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
    if (data.containsKey('low_stock_threshold')) {
      context.handle(
        _lowStockThresholdMeta,
        lowStockThreshold.isAcceptableOrUnknown(
          data['low_stock_threshold']!,
          _lowStockThresholdMeta,
        ),
      );
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
      lowStockThreshold: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}low_stock_threshold'],
      ),
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
  final int? lowStockThreshold;
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
    this.lowStockThreshold,
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
    if (!nullToAbsent || lowStockThreshold != null) {
      map['low_stock_threshold'] = Variable<int>(lowStockThreshold);
    }
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
      lowStockThreshold: lowStockThreshold == null && nullToAbsent
          ? const Value.absent()
          : Value(lowStockThreshold),
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
      lowStockThreshold: serializer.fromJson<int?>(json['lowStockThreshold']),
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
      'lowStockThreshold': serializer.toJson<int?>(lowStockThreshold),
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
    Value<int?> lowStockThreshold = const Value.absent(),
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
    lowStockThreshold: lowStockThreshold.present
        ? lowStockThreshold.value
        : this.lowStockThreshold,
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
      lowStockThreshold: data.lowStockThreshold.present
          ? data.lowStockThreshold.value
          : this.lowStockThreshold,
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
          ..write('blockWhenOutOfStock: $blockWhenOutOfStock, ')
          ..write('lowStockThreshold: $lowStockThreshold')
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
    lowStockThreshold,
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
          other.blockWhenOutOfStock == this.blockWhenOutOfStock &&
          other.lowStockThreshold == this.lowStockThreshold);
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
  final Value<int?> lowStockThreshold;
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
    this.lowStockThreshold = const Value.absent(),
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
    this.lowStockThreshold = const Value.absent(),
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
    Expression<int>? lowStockThreshold,
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
      if (lowStockThreshold != null) 'low_stock_threshold': lowStockThreshold,
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
    Value<int?>? lowStockThreshold,
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
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
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
    if (lowStockThreshold.present) {
      map['low_stock_threshold'] = Variable<int>(lowStockThreshold.value);
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
          ..write('lowStockThreshold: $lowStockThreshold, ')
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
  static const VerificationMeta _guideRefMeta = const VerificationMeta(
    'guideRef',
  );
  @override
  late final GeneratedColumn<String> guideRef = GeneratedColumn<String>(
    'guide_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lotRefMeta = const VerificationMeta('lotRef');
  @override
  late final GeneratedColumn<String> lotRef = GeneratedColumn<String>(
    'lot_ref',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    guideRef,
    lotRef,
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
    if (data.containsKey('guide_ref')) {
      context.handle(
        _guideRefMeta,
        guideRef.isAcceptableOrUnknown(data['guide_ref']!, _guideRefMeta),
      );
    }
    if (data.containsKey('lot_ref')) {
      context.handle(
        _lotRefMeta,
        lotRef.isAcceptableOrUnknown(data['lot_ref']!, _lotRefMeta),
      );
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
      guideRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}guide_ref'],
      ),
      lotRef: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lot_ref'],
      ),
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
  final String? guideRef;
  final String? lotRef;
  const StockMovementRow({
    required this.id,
    required this.storeId,
    required this.productId,
    required this.delta,
    required this.reason,
    this.note,
    this.actorId,
    required this.createdAt,
    this.guideRef,
    this.lotRef,
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
    if (!nullToAbsent || guideRef != null) {
      map['guide_ref'] = Variable<String>(guideRef);
    }
    if (!nullToAbsent || lotRef != null) {
      map['lot_ref'] = Variable<String>(lotRef);
    }
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
      guideRef: guideRef == null && nullToAbsent
          ? const Value.absent()
          : Value(guideRef),
      lotRef: lotRef == null && nullToAbsent
          ? const Value.absent()
          : Value(lotRef),
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
      guideRef: serializer.fromJson<String?>(json['guideRef']),
      lotRef: serializer.fromJson<String?>(json['lotRef']),
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
      'guideRef': serializer.toJson<String?>(guideRef),
      'lotRef': serializer.toJson<String?>(lotRef),
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
    Value<String?> guideRef = const Value.absent(),
    Value<String?> lotRef = const Value.absent(),
  }) => StockMovementRow(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    productId: productId ?? this.productId,
    delta: delta ?? this.delta,
    reason: reason ?? this.reason,
    note: note.present ? note.value : this.note,
    actorId: actorId.present ? actorId.value : this.actorId,
    createdAt: createdAt ?? this.createdAt,
    guideRef: guideRef.present ? guideRef.value : this.guideRef,
    lotRef: lotRef.present ? lotRef.value : this.lotRef,
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
      guideRef: data.guideRef.present ? data.guideRef.value : this.guideRef,
      lotRef: data.lotRef.present ? data.lotRef.value : this.lotRef,
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
          ..write('createdAt: $createdAt, ')
          ..write('guideRef: $guideRef, ')
          ..write('lotRef: $lotRef')
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
    guideRef,
    lotRef,
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
          other.createdAt == this.createdAt &&
          other.guideRef == this.guideRef &&
          other.lotRef == this.lotRef);
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
  final Value<String?> guideRef;
  final Value<String?> lotRef;
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
    this.guideRef = const Value.absent(),
    this.lotRef = const Value.absent(),
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
    this.guideRef = const Value.absent(),
    this.lotRef = const Value.absent(),
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
    Expression<String>? guideRef,
    Expression<String>? lotRef,
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
      if (guideRef != null) 'guide_ref': guideRef,
      if (lotRef != null) 'lot_ref': lotRef,
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
    Value<String?>? guideRef,
    Value<String?>? lotRef,
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
      guideRef: guideRef ?? this.guideRef,
      lotRef: lotRef ?? this.lotRef,
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
    if (guideRef.present) {
      map['guide_ref'] = Variable<String>(guideRef.value);
    }
    if (lotRef.present) {
      map['lot_ref'] = Variable<String>(lotRef.value);
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
          ..write('guideRef: $guideRef, ')
          ..write('lotRef: $lotRef, ')
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
  static const VerificationMeta _sellerCodeMeta = const VerificationMeta(
    'sellerCode',
  );
  @override
  late final GeneratedColumn<String> sellerCode = GeneratedColumn<String>(
    'seller_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _voidedAtMeta = const VerificationMeta(
    'voidedAt',
  );
  @override
  late final GeneratedColumn<String> voidedAt = GeneratedColumn<String>(
    'voided_at',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _voidedByUserIdMeta = const VerificationMeta(
    'voidedByUserId',
  );
  @override
  late final GeneratedColumn<String> voidedByUserId = GeneratedColumn<String>(
    'voided_by_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dteDocumentTypeMeta = const VerificationMeta(
    'dteDocumentType',
  );
  @override
  late final GeneratedColumn<int> dteDocumentType = GeneratedColumn<int>(
    'dte_document_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(39),
  );
  static const VerificationMeta _invoiceReceiverRutMeta =
      const VerificationMeta('invoiceReceiverRut');
  @override
  late final GeneratedColumn<String> invoiceReceiverRut =
      GeneratedColumn<String>(
        'invoice_receiver_rut',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _invoiceReceiverNameMeta =
      const VerificationMeta('invoiceReceiverName');
  @override
  late final GeneratedColumn<String> invoiceReceiverName =
      GeneratedColumn<String>(
        'invoice_receiver_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _invoiceReceiverGiroMeta =
      const VerificationMeta('invoiceReceiverGiro');
  @override
  late final GeneratedColumn<String> invoiceReceiverGiro =
      GeneratedColumn<String>(
        'invoice_receiver_giro',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _invoiceReceiverEmailMeta =
      const VerificationMeta('invoiceReceiverEmail');
  @override
  late final GeneratedColumn<String> invoiceReceiverEmail =
      GeneratedColumn<String>(
        'invoice_receiver_email',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _invoiceReceiverAddressMeta =
      const VerificationMeta('invoiceReceiverAddress');
  @override
  late final GeneratedColumn<String> invoiceReceiverAddress =
      GeneratedColumn<String>(
        'invoice_receiver_address',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _invoiceReceiverCityMeta =
      const VerificationMeta('invoiceReceiverCity');
  @override
  late final GeneratedColumn<String> invoiceReceiverCity =
      GeneratedColumn<String>(
        'invoice_receiver_city',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _invoiceReceiverCommuneMeta =
      const VerificationMeta('invoiceReceiverCommune');
  @override
  late final GeneratedColumn<String> invoiceReceiverCommune =
      GeneratedColumn<String>(
        'invoice_receiver_commune',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _invoiceReceiverPhoneMeta =
      const VerificationMeta('invoiceReceiverPhone');
  @override
  late final GeneratedColumn<String> invoiceReceiverPhone =
      GeneratedColumn<String>(
        'invoice_receiver_phone',
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
    sellerCode,
    voidedAt,
    voidedByUserId,
    dteDocumentType,
    invoiceReceiverRut,
    invoiceReceiverName,
    invoiceReceiverGiro,
    invoiceReceiverEmail,
    invoiceReceiverAddress,
    invoiceReceiverCity,
    invoiceReceiverCommune,
    invoiceReceiverPhone,
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
    if (data.containsKey('seller_code')) {
      context.handle(
        _sellerCodeMeta,
        sellerCode.isAcceptableOrUnknown(data['seller_code']!, _sellerCodeMeta),
      );
    }
    if (data.containsKey('voided_at')) {
      context.handle(
        _voidedAtMeta,
        voidedAt.isAcceptableOrUnknown(data['voided_at']!, _voidedAtMeta),
      );
    }
    if (data.containsKey('voided_by_user_id')) {
      context.handle(
        _voidedByUserIdMeta,
        voidedByUserId.isAcceptableOrUnknown(
          data['voided_by_user_id']!,
          _voidedByUserIdMeta,
        ),
      );
    }
    if (data.containsKey('dte_document_type')) {
      context.handle(
        _dteDocumentTypeMeta,
        dteDocumentType.isAcceptableOrUnknown(
          data['dte_document_type']!,
          _dteDocumentTypeMeta,
        ),
      );
    }
    if (data.containsKey('invoice_receiver_rut')) {
      context.handle(
        _invoiceReceiverRutMeta,
        invoiceReceiverRut.isAcceptableOrUnknown(
          data['invoice_receiver_rut']!,
          _invoiceReceiverRutMeta,
        ),
      );
    }
    if (data.containsKey('invoice_receiver_name')) {
      context.handle(
        _invoiceReceiverNameMeta,
        invoiceReceiverName.isAcceptableOrUnknown(
          data['invoice_receiver_name']!,
          _invoiceReceiverNameMeta,
        ),
      );
    }
    if (data.containsKey('invoice_receiver_giro')) {
      context.handle(
        _invoiceReceiverGiroMeta,
        invoiceReceiverGiro.isAcceptableOrUnknown(
          data['invoice_receiver_giro']!,
          _invoiceReceiverGiroMeta,
        ),
      );
    }
    if (data.containsKey('invoice_receiver_email')) {
      context.handle(
        _invoiceReceiverEmailMeta,
        invoiceReceiverEmail.isAcceptableOrUnknown(
          data['invoice_receiver_email']!,
          _invoiceReceiverEmailMeta,
        ),
      );
    }
    if (data.containsKey('invoice_receiver_address')) {
      context.handle(
        _invoiceReceiverAddressMeta,
        invoiceReceiverAddress.isAcceptableOrUnknown(
          data['invoice_receiver_address']!,
          _invoiceReceiverAddressMeta,
        ),
      );
    }
    if (data.containsKey('invoice_receiver_city')) {
      context.handle(
        _invoiceReceiverCityMeta,
        invoiceReceiverCity.isAcceptableOrUnknown(
          data['invoice_receiver_city']!,
          _invoiceReceiverCityMeta,
        ),
      );
    }
    if (data.containsKey('invoice_receiver_commune')) {
      context.handle(
        _invoiceReceiverCommuneMeta,
        invoiceReceiverCommune.isAcceptableOrUnknown(
          data['invoice_receiver_commune']!,
          _invoiceReceiverCommuneMeta,
        ),
      );
    }
    if (data.containsKey('invoice_receiver_phone')) {
      context.handle(
        _invoiceReceiverPhoneMeta,
        invoiceReceiverPhone.isAcceptableOrUnknown(
          data['invoice_receiver_phone']!,
          _invoiceReceiverPhoneMeta,
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
      sellerCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}seller_code'],
      ),
      voidedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}voided_at'],
      ),
      voidedByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}voided_by_user_id'],
      ),
      dteDocumentType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}dte_document_type'],
      )!,
      invoiceReceiverRut: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_receiver_rut'],
      ),
      invoiceReceiverName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_receiver_name'],
      ),
      invoiceReceiverGiro: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_receiver_giro'],
      ),
      invoiceReceiverEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_receiver_email'],
      ),
      invoiceReceiverAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_receiver_address'],
      ),
      invoiceReceiverCity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_receiver_city'],
      ),
      invoiceReceiverCommune: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_receiver_commune'],
      ),
      invoiceReceiverPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invoice_receiver_phone'],
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
  final String? sellerCode;
  final String? voidedAt;
  final String? voidedByUserId;
  final int dteDocumentType;
  final String? invoiceReceiverRut;
  final String? invoiceReceiverName;
  final String? invoiceReceiverGiro;
  final String? invoiceReceiverEmail;
  final String? invoiceReceiverAddress;
  final String? invoiceReceiverCity;
  final String? invoiceReceiverCommune;
  final String? invoiceReceiverPhone;
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
    this.sellerCode,
    this.voidedAt,
    this.voidedByUserId,
    required this.dteDocumentType,
    this.invoiceReceiverRut,
    this.invoiceReceiverName,
    this.invoiceReceiverGiro,
    this.invoiceReceiverEmail,
    this.invoiceReceiverAddress,
    this.invoiceReceiverCity,
    this.invoiceReceiverCommune,
    this.invoiceReceiverPhone,
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
    if (!nullToAbsent || sellerCode != null) {
      map['seller_code'] = Variable<String>(sellerCode);
    }
    if (!nullToAbsent || voidedAt != null) {
      map['voided_at'] = Variable<String>(voidedAt);
    }
    if (!nullToAbsent || voidedByUserId != null) {
      map['voided_by_user_id'] = Variable<String>(voidedByUserId);
    }
    map['dte_document_type'] = Variable<int>(dteDocumentType);
    if (!nullToAbsent || invoiceReceiverRut != null) {
      map['invoice_receiver_rut'] = Variable<String>(invoiceReceiverRut);
    }
    if (!nullToAbsent || invoiceReceiverName != null) {
      map['invoice_receiver_name'] = Variable<String>(invoiceReceiverName);
    }
    if (!nullToAbsent || invoiceReceiverGiro != null) {
      map['invoice_receiver_giro'] = Variable<String>(invoiceReceiverGiro);
    }
    if (!nullToAbsent || invoiceReceiverEmail != null) {
      map['invoice_receiver_email'] = Variable<String>(invoiceReceiverEmail);
    }
    if (!nullToAbsent || invoiceReceiverAddress != null) {
      map['invoice_receiver_address'] = Variable<String>(
        invoiceReceiverAddress,
      );
    }
    if (!nullToAbsent || invoiceReceiverCity != null) {
      map['invoice_receiver_city'] = Variable<String>(invoiceReceiverCity);
    }
    if (!nullToAbsent || invoiceReceiverCommune != null) {
      map['invoice_receiver_commune'] = Variable<String>(
        invoiceReceiverCommune,
      );
    }
    if (!nullToAbsent || invoiceReceiverPhone != null) {
      map['invoice_receiver_phone'] = Variable<String>(invoiceReceiverPhone);
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
      sellerCode: sellerCode == null && nullToAbsent
          ? const Value.absent()
          : Value(sellerCode),
      voidedAt: voidedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(voidedAt),
      voidedByUserId: voidedByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(voidedByUserId),
      dteDocumentType: Value(dteDocumentType),
      invoiceReceiverRut: invoiceReceiverRut == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceReceiverRut),
      invoiceReceiverName: invoiceReceiverName == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceReceiverName),
      invoiceReceiverGiro: invoiceReceiverGiro == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceReceiverGiro),
      invoiceReceiverEmail: invoiceReceiverEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceReceiverEmail),
      invoiceReceiverAddress: invoiceReceiverAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceReceiverAddress),
      invoiceReceiverCity: invoiceReceiverCity == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceReceiverCity),
      invoiceReceiverCommune: invoiceReceiverCommune == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceReceiverCommune),
      invoiceReceiverPhone: invoiceReceiverPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(invoiceReceiverPhone),
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
      sellerCode: serializer.fromJson<String?>(json['sellerCode']),
      voidedAt: serializer.fromJson<String?>(json['voidedAt']),
      voidedByUserId: serializer.fromJson<String?>(json['voidedByUserId']),
      dteDocumentType: serializer.fromJson<int>(json['dteDocumentType']),
      invoiceReceiverRut: serializer.fromJson<String?>(
        json['invoiceReceiverRut'],
      ),
      invoiceReceiverName: serializer.fromJson<String?>(
        json['invoiceReceiverName'],
      ),
      invoiceReceiverGiro: serializer.fromJson<String?>(
        json['invoiceReceiverGiro'],
      ),
      invoiceReceiverEmail: serializer.fromJson<String?>(
        json['invoiceReceiverEmail'],
      ),
      invoiceReceiverAddress: serializer.fromJson<String?>(
        json['invoiceReceiverAddress'],
      ),
      invoiceReceiverCity: serializer.fromJson<String?>(
        json['invoiceReceiverCity'],
      ),
      invoiceReceiverCommune: serializer.fromJson<String?>(
        json['invoiceReceiverCommune'],
      ),
      invoiceReceiverPhone: serializer.fromJson<String?>(
        json['invoiceReceiverPhone'],
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
      'sellerCode': serializer.toJson<String?>(sellerCode),
      'voidedAt': serializer.toJson<String?>(voidedAt),
      'voidedByUserId': serializer.toJson<String?>(voidedByUserId),
      'dteDocumentType': serializer.toJson<int>(dteDocumentType),
      'invoiceReceiverRut': serializer.toJson<String?>(invoiceReceiverRut),
      'invoiceReceiverName': serializer.toJson<String?>(invoiceReceiverName),
      'invoiceReceiverGiro': serializer.toJson<String?>(invoiceReceiverGiro),
      'invoiceReceiverEmail': serializer.toJson<String?>(invoiceReceiverEmail),
      'invoiceReceiverAddress': serializer.toJson<String?>(
        invoiceReceiverAddress,
      ),
      'invoiceReceiverCity': serializer.toJson<String?>(invoiceReceiverCity),
      'invoiceReceiverCommune': serializer.toJson<String?>(
        invoiceReceiverCommune,
      ),
      'invoiceReceiverPhone': serializer.toJson<String?>(invoiceReceiverPhone),
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
    Value<String?> sellerCode = const Value.absent(),
    Value<String?> voidedAt = const Value.absent(),
    Value<String?> voidedByUserId = const Value.absent(),
    int? dteDocumentType,
    Value<String?> invoiceReceiverRut = const Value.absent(),
    Value<String?> invoiceReceiverName = const Value.absent(),
    Value<String?> invoiceReceiverGiro = const Value.absent(),
    Value<String?> invoiceReceiverEmail = const Value.absent(),
    Value<String?> invoiceReceiverAddress = const Value.absent(),
    Value<String?> invoiceReceiverCity = const Value.absent(),
    Value<String?> invoiceReceiverCommune = const Value.absent(),
    Value<String?> invoiceReceiverPhone = const Value.absent(),
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
    sellerCode: sellerCode.present ? sellerCode.value : this.sellerCode,
    voidedAt: voidedAt.present ? voidedAt.value : this.voidedAt,
    voidedByUserId: voidedByUserId.present
        ? voidedByUserId.value
        : this.voidedByUserId,
    dteDocumentType: dteDocumentType ?? this.dteDocumentType,
    invoiceReceiverRut: invoiceReceiverRut.present
        ? invoiceReceiverRut.value
        : this.invoiceReceiverRut,
    invoiceReceiverName: invoiceReceiverName.present
        ? invoiceReceiverName.value
        : this.invoiceReceiverName,
    invoiceReceiverGiro: invoiceReceiverGiro.present
        ? invoiceReceiverGiro.value
        : this.invoiceReceiverGiro,
    invoiceReceiverEmail: invoiceReceiverEmail.present
        ? invoiceReceiverEmail.value
        : this.invoiceReceiverEmail,
    invoiceReceiverAddress: invoiceReceiverAddress.present
        ? invoiceReceiverAddress.value
        : this.invoiceReceiverAddress,
    invoiceReceiverCity: invoiceReceiverCity.present
        ? invoiceReceiverCity.value
        : this.invoiceReceiverCity,
    invoiceReceiverCommune: invoiceReceiverCommune.present
        ? invoiceReceiverCommune.value
        : this.invoiceReceiverCommune,
    invoiceReceiverPhone: invoiceReceiverPhone.present
        ? invoiceReceiverPhone.value
        : this.invoiceReceiverPhone,
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
      sellerCode: data.sellerCode.present
          ? data.sellerCode.value
          : this.sellerCode,
      voidedAt: data.voidedAt.present ? data.voidedAt.value : this.voidedAt,
      voidedByUserId: data.voidedByUserId.present
          ? data.voidedByUserId.value
          : this.voidedByUserId,
      dteDocumentType: data.dteDocumentType.present
          ? data.dteDocumentType.value
          : this.dteDocumentType,
      invoiceReceiverRut: data.invoiceReceiverRut.present
          ? data.invoiceReceiverRut.value
          : this.invoiceReceiverRut,
      invoiceReceiverName: data.invoiceReceiverName.present
          ? data.invoiceReceiverName.value
          : this.invoiceReceiverName,
      invoiceReceiverGiro: data.invoiceReceiverGiro.present
          ? data.invoiceReceiverGiro.value
          : this.invoiceReceiverGiro,
      invoiceReceiverEmail: data.invoiceReceiverEmail.present
          ? data.invoiceReceiverEmail.value
          : this.invoiceReceiverEmail,
      invoiceReceiverAddress: data.invoiceReceiverAddress.present
          ? data.invoiceReceiverAddress.value
          : this.invoiceReceiverAddress,
      invoiceReceiverCity: data.invoiceReceiverCity.present
          ? data.invoiceReceiverCity.value
          : this.invoiceReceiverCity,
      invoiceReceiverCommune: data.invoiceReceiverCommune.present
          ? data.invoiceReceiverCommune.value
          : this.invoiceReceiverCommune,
      invoiceReceiverPhone: data.invoiceReceiverPhone.present
          ? data.invoiceReceiverPhone.value
          : this.invoiceReceiverPhone,
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
          ..write('confirmedByUserId: $confirmedByUserId, ')
          ..write('sellerCode: $sellerCode, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('voidedByUserId: $voidedByUserId, ')
          ..write('dteDocumentType: $dteDocumentType, ')
          ..write('invoiceReceiverRut: $invoiceReceiverRut, ')
          ..write('invoiceReceiverName: $invoiceReceiverName, ')
          ..write('invoiceReceiverGiro: $invoiceReceiverGiro, ')
          ..write('invoiceReceiverEmail: $invoiceReceiverEmail, ')
          ..write('invoiceReceiverAddress: $invoiceReceiverAddress, ')
          ..write('invoiceReceiverCity: $invoiceReceiverCity, ')
          ..write('invoiceReceiverCommune: $invoiceReceiverCommune, ')
          ..write('invoiceReceiverPhone: $invoiceReceiverPhone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
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
    sellerCode,
    voidedAt,
    voidedByUserId,
    dteDocumentType,
    invoiceReceiverRut,
    invoiceReceiverName,
    invoiceReceiverGiro,
    invoiceReceiverEmail,
    invoiceReceiverAddress,
    invoiceReceiverCity,
    invoiceReceiverCommune,
    invoiceReceiverPhone,
  ]);
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
          other.confirmedByUserId == this.confirmedByUserId &&
          other.sellerCode == this.sellerCode &&
          other.voidedAt == this.voidedAt &&
          other.voidedByUserId == this.voidedByUserId &&
          other.dteDocumentType == this.dteDocumentType &&
          other.invoiceReceiverRut == this.invoiceReceiverRut &&
          other.invoiceReceiverName == this.invoiceReceiverName &&
          other.invoiceReceiverGiro == this.invoiceReceiverGiro &&
          other.invoiceReceiverEmail == this.invoiceReceiverEmail &&
          other.invoiceReceiverAddress == this.invoiceReceiverAddress &&
          other.invoiceReceiverCity == this.invoiceReceiverCity &&
          other.invoiceReceiverCommune == this.invoiceReceiverCommune &&
          other.invoiceReceiverPhone == this.invoiceReceiverPhone);
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
  final Value<String?> sellerCode;
  final Value<String?> voidedAt;
  final Value<String?> voidedByUserId;
  final Value<int> dteDocumentType;
  final Value<String?> invoiceReceiverRut;
  final Value<String?> invoiceReceiverName;
  final Value<String?> invoiceReceiverGiro;
  final Value<String?> invoiceReceiverEmail;
  final Value<String?> invoiceReceiverAddress;
  final Value<String?> invoiceReceiverCity;
  final Value<String?> invoiceReceiverCommune;
  final Value<String?> invoiceReceiverPhone;
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
    this.sellerCode = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.voidedByUserId = const Value.absent(),
    this.dteDocumentType = const Value.absent(),
    this.invoiceReceiverRut = const Value.absent(),
    this.invoiceReceiverName = const Value.absent(),
    this.invoiceReceiverGiro = const Value.absent(),
    this.invoiceReceiverEmail = const Value.absent(),
    this.invoiceReceiverAddress = const Value.absent(),
    this.invoiceReceiverCity = const Value.absent(),
    this.invoiceReceiverCommune = const Value.absent(),
    this.invoiceReceiverPhone = const Value.absent(),
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
    this.sellerCode = const Value.absent(),
    this.voidedAt = const Value.absent(),
    this.voidedByUserId = const Value.absent(),
    this.dteDocumentType = const Value.absent(),
    this.invoiceReceiverRut = const Value.absent(),
    this.invoiceReceiverName = const Value.absent(),
    this.invoiceReceiverGiro = const Value.absent(),
    this.invoiceReceiverEmail = const Value.absent(),
    this.invoiceReceiverAddress = const Value.absent(),
    this.invoiceReceiverCity = const Value.absent(),
    this.invoiceReceiverCommune = const Value.absent(),
    this.invoiceReceiverPhone = const Value.absent(),
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
    Expression<String>? sellerCode,
    Expression<String>? voidedAt,
    Expression<String>? voidedByUserId,
    Expression<int>? dteDocumentType,
    Expression<String>? invoiceReceiverRut,
    Expression<String>? invoiceReceiverName,
    Expression<String>? invoiceReceiverGiro,
    Expression<String>? invoiceReceiverEmail,
    Expression<String>? invoiceReceiverAddress,
    Expression<String>? invoiceReceiverCity,
    Expression<String>? invoiceReceiverCommune,
    Expression<String>? invoiceReceiverPhone,
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
      if (sellerCode != null) 'seller_code': sellerCode,
      if (voidedAt != null) 'voided_at': voidedAt,
      if (voidedByUserId != null) 'voided_by_user_id': voidedByUserId,
      if (dteDocumentType != null) 'dte_document_type': dteDocumentType,
      if (invoiceReceiverRut != null)
        'invoice_receiver_rut': invoiceReceiverRut,
      if (invoiceReceiverName != null)
        'invoice_receiver_name': invoiceReceiverName,
      if (invoiceReceiverGiro != null)
        'invoice_receiver_giro': invoiceReceiverGiro,
      if (invoiceReceiverEmail != null)
        'invoice_receiver_email': invoiceReceiverEmail,
      if (invoiceReceiverAddress != null)
        'invoice_receiver_address': invoiceReceiverAddress,
      if (invoiceReceiverCity != null)
        'invoice_receiver_city': invoiceReceiverCity,
      if (invoiceReceiverCommune != null)
        'invoice_receiver_commune': invoiceReceiverCommune,
      if (invoiceReceiverPhone != null)
        'invoice_receiver_phone': invoiceReceiverPhone,
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
    Value<String?>? sellerCode,
    Value<String?>? voidedAt,
    Value<String?>? voidedByUserId,
    Value<int>? dteDocumentType,
    Value<String?>? invoiceReceiverRut,
    Value<String?>? invoiceReceiverName,
    Value<String?>? invoiceReceiverGiro,
    Value<String?>? invoiceReceiverEmail,
    Value<String?>? invoiceReceiverAddress,
    Value<String?>? invoiceReceiverCity,
    Value<String?>? invoiceReceiverCommune,
    Value<String?>? invoiceReceiverPhone,
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
      sellerCode: sellerCode ?? this.sellerCode,
      voidedAt: voidedAt ?? this.voidedAt,
      voidedByUserId: voidedByUserId ?? this.voidedByUserId,
      dteDocumentType: dteDocumentType ?? this.dteDocumentType,
      invoiceReceiverRut: invoiceReceiverRut ?? this.invoiceReceiverRut,
      invoiceReceiverName: invoiceReceiverName ?? this.invoiceReceiverName,
      invoiceReceiverGiro: invoiceReceiverGiro ?? this.invoiceReceiverGiro,
      invoiceReceiverEmail: invoiceReceiverEmail ?? this.invoiceReceiverEmail,
      invoiceReceiverAddress:
          invoiceReceiverAddress ?? this.invoiceReceiverAddress,
      invoiceReceiverCity: invoiceReceiverCity ?? this.invoiceReceiverCity,
      invoiceReceiverCommune:
          invoiceReceiverCommune ?? this.invoiceReceiverCommune,
      invoiceReceiverPhone: invoiceReceiverPhone ?? this.invoiceReceiverPhone,
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
    if (sellerCode.present) {
      map['seller_code'] = Variable<String>(sellerCode.value);
    }
    if (voidedAt.present) {
      map['voided_at'] = Variable<String>(voidedAt.value);
    }
    if (voidedByUserId.present) {
      map['voided_by_user_id'] = Variable<String>(voidedByUserId.value);
    }
    if (dteDocumentType.present) {
      map['dte_document_type'] = Variable<int>(dteDocumentType.value);
    }
    if (invoiceReceiverRut.present) {
      map['invoice_receiver_rut'] = Variable<String>(invoiceReceiverRut.value);
    }
    if (invoiceReceiverName.present) {
      map['invoice_receiver_name'] = Variable<String>(
        invoiceReceiverName.value,
      );
    }
    if (invoiceReceiverGiro.present) {
      map['invoice_receiver_giro'] = Variable<String>(
        invoiceReceiverGiro.value,
      );
    }
    if (invoiceReceiverEmail.present) {
      map['invoice_receiver_email'] = Variable<String>(
        invoiceReceiverEmail.value,
      );
    }
    if (invoiceReceiverAddress.present) {
      map['invoice_receiver_address'] = Variable<String>(
        invoiceReceiverAddress.value,
      );
    }
    if (invoiceReceiverCity.present) {
      map['invoice_receiver_city'] = Variable<String>(
        invoiceReceiverCity.value,
      );
    }
    if (invoiceReceiverCommune.present) {
      map['invoice_receiver_commune'] = Variable<String>(
        invoiceReceiverCommune.value,
      );
    }
    if (invoiceReceiverPhone.present) {
      map['invoice_receiver_phone'] = Variable<String>(
        invoiceReceiverPhone.value,
      );
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
          ..write('sellerCode: $sellerCode, ')
          ..write('voidedAt: $voidedAt, ')
          ..write('voidedByUserId: $voidedByUserId, ')
          ..write('dteDocumentType: $dteDocumentType, ')
          ..write('invoiceReceiverRut: $invoiceReceiverRut, ')
          ..write('invoiceReceiverName: $invoiceReceiverName, ')
          ..write('invoiceReceiverGiro: $invoiceReceiverGiro, ')
          ..write('invoiceReceiverEmail: $invoiceReceiverEmail, ')
          ..write('invoiceReceiverAddress: $invoiceReceiverAddress, ')
          ..write('invoiceReceiverCity: $invoiceReceiverCity, ')
          ..write('invoiceReceiverCommune: $invoiceReceiverCommune, ')
          ..write('invoiceReceiverPhone: $invoiceReceiverPhone, ')
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
  static const VerificationMeta _documentIdMeta = const VerificationMeta(
    'documentId',
  );
  @override
  late final GeneratedColumn<String> documentId = GeneratedColumn<String>(
    'document_id',
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
    requiredDuringInsert: false,
    defaultValue: const Constant(39),
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
    documentId,
    saleId,
    storeId,
    documentType,
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
    if (data.containsKey('document_id')) {
      context.handle(
        _documentIdMeta,
        documentId.isAcceptableOrUnknown(data['document_id']!, _documentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
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
    if (data.containsKey('document_type')) {
      context.handle(
        _documentTypeMeta,
        documentType.isAcceptableOrUnknown(
          data['document_type']!,
          _documentTypeMeta,
        ),
      );
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
  Set<GeneratedColumn> get $primaryKey => {documentId};
  @override
  DteQueueRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DteQueueRow(
      documentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}document_id'],
      )!,
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      documentType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}document_type'],
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
  final String documentId;
  final String saleId;
  final String storeId;
  final int documentType;
  final int attempts;
  final String? lastError;
  final String createdAt;
  const DteQueueRow({
    required this.documentId,
    required this.saleId,
    required this.storeId,
    required this.documentType,
    required this.attempts,
    this.lastError,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['document_id'] = Variable<String>(documentId);
    map['sale_id'] = Variable<String>(saleId);
    map['store_id'] = Variable<String>(storeId);
    map['document_type'] = Variable<int>(documentType);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  DteQueueCompanion toCompanion(bool nullToAbsent) {
    return DteQueueCompanion(
      documentId: Value(documentId),
      saleId: Value(saleId),
      storeId: Value(storeId),
      documentType: Value(documentType),
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
      documentId: serializer.fromJson<String>(json['documentId']),
      saleId: serializer.fromJson<String>(json['saleId']),
      storeId: serializer.fromJson<String>(json['storeId']),
      documentType: serializer.fromJson<int>(json['documentType']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'documentId': serializer.toJson<String>(documentId),
      'saleId': serializer.toJson<String>(saleId),
      'storeId': serializer.toJson<String>(storeId),
      'documentType': serializer.toJson<int>(documentType),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  DteQueueRow copyWith({
    String? documentId,
    String? saleId,
    String? storeId,
    int? documentType,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
    String? createdAt,
  }) => DteQueueRow(
    documentId: documentId ?? this.documentId,
    saleId: saleId ?? this.saleId,
    storeId: storeId ?? this.storeId,
    documentType: documentType ?? this.documentType,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
    createdAt: createdAt ?? this.createdAt,
  );
  DteQueueRow copyWithCompanion(DteQueueCompanion data) {
    return DteQueueRow(
      documentId: data.documentId.present
          ? data.documentId.value
          : this.documentId,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      documentType: data.documentType.present
          ? data.documentType.value
          : this.documentType,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DteQueueRow(')
          ..write('documentId: $documentId, ')
          ..write('saleId: $saleId, ')
          ..write('storeId: $storeId, ')
          ..write('documentType: $documentType, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    documentId,
    saleId,
    storeId,
    documentType,
    attempts,
    lastError,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DteQueueRow &&
          other.documentId == this.documentId &&
          other.saleId == this.saleId &&
          other.storeId == this.storeId &&
          other.documentType == this.documentType &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.createdAt == this.createdAt);
}

class DteQueueCompanion extends UpdateCompanion<DteQueueRow> {
  final Value<String> documentId;
  final Value<String> saleId;
  final Value<String> storeId;
  final Value<int> documentType;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<String> createdAt;
  final Value<int> rowid;
  const DteQueueCompanion({
    this.documentId = const Value.absent(),
    this.saleId = const Value.absent(),
    this.storeId = const Value.absent(),
    this.documentType = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DteQueueCompanion.insert({
    required String documentId,
    required String saleId,
    required String storeId,
    this.documentType = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    required String createdAt,
    this.rowid = const Value.absent(),
  }) : documentId = Value(documentId),
       saleId = Value(saleId),
       storeId = Value(storeId),
       createdAt = Value(createdAt);
  static Insertable<DteQueueRow> custom({
    Expression<String>? documentId,
    Expression<String>? saleId,
    Expression<String>? storeId,
    Expression<int>? documentType,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<String>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (documentId != null) 'document_id': documentId,
      if (saleId != null) 'sale_id': saleId,
      if (storeId != null) 'store_id': storeId,
      if (documentType != null) 'document_type': documentType,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DteQueueCompanion copyWith({
    Value<String>? documentId,
    Value<String>? saleId,
    Value<String>? storeId,
    Value<int>? documentType,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<String>? createdAt,
    Value<int>? rowid,
  }) {
    return DteQueueCompanion(
      documentId: documentId ?? this.documentId,
      saleId: saleId ?? this.saleId,
      storeId: storeId ?? this.storeId,
      documentType: documentType ?? this.documentType,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (documentId.present) {
      map['document_id'] = Variable<String>(documentId.value);
    }
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (documentType.present) {
      map['document_type'] = Variable<int>(documentType.value);
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
          ..write('documentId: $documentId, ')
          ..write('saleId: $saleId, ')
          ..write('storeId: $storeId, ')
          ..write('documentType: $documentType, ')
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
  static const VerificationMeta _createdByUserIdMeta = const VerificationMeta(
    'createdByUserId',
  );
  @override
  late final GeneratedColumn<String> createdByUserId = GeneratedColumn<String>(
    'created_by_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    createdAt,
    createdByUserId,
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('created_by_user_id')) {
      context.handle(
        _createdByUserIdMeta,
        createdByUserId.isAcceptableOrUnknown(
          data['created_by_user_id']!,
          _createdByUserIdMeta,
        ),
      );
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
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      createdByUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by_user_id'],
      ),
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
  final String createdAt;
  final String? createdByUserId;
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
    required this.createdAt,
    this.createdByUserId,
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
    map['created_at'] = Variable<String>(createdAt);
    if (!nullToAbsent || createdByUserId != null) {
      map['created_by_user_id'] = Variable<String>(createdByUserId);
    }
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
      createdAt: Value(createdAt),
      createdByUserId: createdByUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(createdByUserId),
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
      createdAt: serializer.fromJson<String>(json['createdAt']),
      createdByUserId: serializer.fromJson<String?>(json['createdByUserId']),
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
      'createdAt': serializer.toJson<String>(createdAt),
      'createdByUserId': serializer.toJson<String?>(createdByUserId),
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
    String? createdAt,
    Value<String?> createdByUserId = const Value.absent(),
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
    createdAt: createdAt ?? this.createdAt,
    createdByUserId: createdByUserId.present
        ? createdByUserId.value
        : this.createdByUserId,
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
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      createdByUserId: data.createdByUserId.present
          ? data.createdByUserId.value
          : this.createdByUserId,
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
          ..write('userRut: $userRut, ')
          ..write('createdAt: $createdAt, ')
          ..write('createdByUserId: $createdByUserId')
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
    createdAt,
    createdByUserId,
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
          other.userRut == this.userRut &&
          other.createdAt == this.createdAt &&
          other.createdByUserId == this.createdByUserId);
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
  final Value<String> createdAt;
  final Value<String?> createdByUserId;
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
    this.createdAt = const Value.absent(),
    this.createdByUserId = const Value.absent(),
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
    required String createdAt,
    this.createdByUserId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       role = Value(role),
       pinHash = Value(pinHash),
       displayName = Value(displayName),
       username = Value(username),
       firstName = Value(firstName),
       lastName = Value(lastName),
       userRut = Value(userRut),
       createdAt = Value(createdAt);
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
    Expression<String>? createdAt,
    Expression<String>? createdByUserId,
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
      if (createdAt != null) 'created_at': createdAt,
      if (createdByUserId != null) 'created_by_user_id': createdByUserId,
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
    Value<String>? createdAt,
    Value<String?>? createdByUserId,
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
      createdAt: createdAt ?? this.createdAt,
      createdByUserId: createdByUserId ?? this.createdByUserId,
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
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (createdByUserId.present) {
      map['created_by_user_id'] = Variable<String>(createdByUserId.value);
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
          ..write('createdAt: $createdAt, ')
          ..write('createdByUserId: $createdByUserId, ')
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

class $InventoryClosesTable extends InventoryCloses
    with TableInfo<$InventoryClosesTable, InventoryCloseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryClosesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _actorUserIdMeta = const VerificationMeta(
    'actorUserId',
  );
  @override
  late final GeneratedColumn<String> actorUserId = GeneratedColumn<String>(
    'actor_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    shiftId,
    createdAt,
    actorUserId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_closes';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryCloseRow> instance, {
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('actor_user_id')) {
      context.handle(
        _actorUserIdMeta,
        actorUserId.isAcceptableOrUnknown(
          data['actor_user_id']!,
          _actorUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actorUserIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryCloseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryCloseRow(
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
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      actorUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor_user_id'],
      )!,
    );
  }

  @override
  $InventoryClosesTable createAlias(String alias) {
    return $InventoryClosesTable(attachedDatabase, alias);
  }
}

class InventoryCloseRow extends DataClass
    implements Insertable<InventoryCloseRow> {
  final String id;
  final String storeId;
  final String shiftId;
  final String createdAt;
  final String actorUserId;
  const InventoryCloseRow({
    required this.id,
    required this.storeId,
    required this.shiftId,
    required this.createdAt,
    required this.actorUserId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['shift_id'] = Variable<String>(shiftId);
    map['created_at'] = Variable<String>(createdAt);
    map['actor_user_id'] = Variable<String>(actorUserId);
    return map;
  }

  InventoryClosesCompanion toCompanion(bool nullToAbsent) {
    return InventoryClosesCompanion(
      id: Value(id),
      storeId: Value(storeId),
      shiftId: Value(shiftId),
      createdAt: Value(createdAt),
      actorUserId: Value(actorUserId),
    );
  }

  factory InventoryCloseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryCloseRow(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      shiftId: serializer.fromJson<String>(json['shiftId']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      actorUserId: serializer.fromJson<String>(json['actorUserId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'shiftId': serializer.toJson<String>(shiftId),
      'createdAt': serializer.toJson<String>(createdAt),
      'actorUserId': serializer.toJson<String>(actorUserId),
    };
  }

  InventoryCloseRow copyWith({
    String? id,
    String? storeId,
    String? shiftId,
    String? createdAt,
    String? actorUserId,
  }) => InventoryCloseRow(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    shiftId: shiftId ?? this.shiftId,
    createdAt: createdAt ?? this.createdAt,
    actorUserId: actorUserId ?? this.actorUserId,
  );
  InventoryCloseRow copyWithCompanion(InventoryClosesCompanion data) {
    return InventoryCloseRow(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      actorUserId: data.actorUserId.present
          ? data.actorUserId.value
          : this.actorUserId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryCloseRow(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('shiftId: $shiftId, ')
          ..write('createdAt: $createdAt, ')
          ..write('actorUserId: $actorUserId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, storeId, shiftId, createdAt, actorUserId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryCloseRow &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.shiftId == this.shiftId &&
          other.createdAt == this.createdAt &&
          other.actorUserId == this.actorUserId);
}

class InventoryClosesCompanion extends UpdateCompanion<InventoryCloseRow> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<String> shiftId;
  final Value<String> createdAt;
  final Value<String> actorUserId;
  final Value<int> rowid;
  const InventoryClosesCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.actorUserId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryClosesCompanion.insert({
    required String id,
    required String storeId,
    required String shiftId,
    required String createdAt,
    required String actorUserId,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       shiftId = Value(shiftId),
       createdAt = Value(createdAt),
       actorUserId = Value(actorUserId);
  static Insertable<InventoryCloseRow> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<String>? shiftId,
    Expression<String>? createdAt,
    Expression<String>? actorUserId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (shiftId != null) 'shift_id': shiftId,
      if (createdAt != null) 'created_at': createdAt,
      if (actorUserId != null) 'actor_user_id': actorUserId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryClosesCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<String>? shiftId,
    Value<String>? createdAt,
    Value<String>? actorUserId,
    Value<int>? rowid,
  }) {
    return InventoryClosesCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      shiftId: shiftId ?? this.shiftId,
      createdAt: createdAt ?? this.createdAt,
      actorUserId: actorUserId ?? this.actorUserId,
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
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (actorUserId.present) {
      map['actor_user_id'] = Variable<String>(actorUserId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryClosesCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('shiftId: $shiftId, ')
          ..write('createdAt: $createdAt, ')
          ..write('actorUserId: $actorUserId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InventoryCloseLinesTable extends InventoryCloseLines
    with TableInfo<$InventoryCloseLinesTable, InventoryCloseLineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryCloseLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _closeIdMeta = const VerificationMeta(
    'closeId',
  );
  @override
  late final GeneratedColumn<String> closeId = GeneratedColumn<String>(
    'close_id',
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
  static const VerificationMeta _systemStockMeta = const VerificationMeta(
    'systemStock',
  );
  @override
  late final GeneratedColumn<int> systemStock = GeneratedColumn<int>(
    'system_stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countedStockMeta = const VerificationMeta(
    'countedStock',
  );
  @override
  late final GeneratedColumn<int> countedStock = GeneratedColumn<int>(
    'counted_stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _varianceMeta = const VerificationMeta(
    'variance',
  );
  @override
  late final GeneratedColumn<int> variance = GeneratedColumn<int>(
    'variance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitsSoldInShiftMeta = const VerificationMeta(
    'unitsSoldInShift',
  );
  @override
  late final GeneratedColumn<int> unitsSoldInShift = GeneratedColumn<int>(
    'units_sold_in_shift',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    closeId,
    productId,
    systemStock,
    countedStock,
    variance,
    unitsSoldInShift,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_close_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryCloseLineRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('close_id')) {
      context.handle(
        _closeIdMeta,
        closeId.isAcceptableOrUnknown(data['close_id']!, _closeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_closeIdMeta);
    }
    if (data.containsKey('product_id')) {
      context.handle(
        _productIdMeta,
        productId.isAcceptableOrUnknown(data['product_id']!, _productIdMeta),
      );
    } else if (isInserting) {
      context.missing(_productIdMeta);
    }
    if (data.containsKey('system_stock')) {
      context.handle(
        _systemStockMeta,
        systemStock.isAcceptableOrUnknown(
          data['system_stock']!,
          _systemStockMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_systemStockMeta);
    }
    if (data.containsKey('counted_stock')) {
      context.handle(
        _countedStockMeta,
        countedStock.isAcceptableOrUnknown(
          data['counted_stock']!,
          _countedStockMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_countedStockMeta);
    }
    if (data.containsKey('variance')) {
      context.handle(
        _varianceMeta,
        variance.isAcceptableOrUnknown(data['variance']!, _varianceMeta),
      );
    } else if (isInserting) {
      context.missing(_varianceMeta);
    }
    if (data.containsKey('units_sold_in_shift')) {
      context.handle(
        _unitsSoldInShiftMeta,
        unitsSoldInShift.isAcceptableOrUnknown(
          data['units_sold_in_shift']!,
          _unitsSoldInShiftMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unitsSoldInShiftMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryCloseLineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryCloseLineRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      closeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}close_id'],
      )!,
      productId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}product_id'],
      )!,
      systemStock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}system_stock'],
      )!,
      countedStock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}counted_stock'],
      )!,
      variance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}variance'],
      )!,
      unitsSoldInShift: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}units_sold_in_shift'],
      )!,
    );
  }

  @override
  $InventoryCloseLinesTable createAlias(String alias) {
    return $InventoryCloseLinesTable(attachedDatabase, alias);
  }
}

class InventoryCloseLineRow extends DataClass
    implements Insertable<InventoryCloseLineRow> {
  final String id;
  final String closeId;
  final String productId;
  final int systemStock;
  final int countedStock;
  final int variance;
  final int unitsSoldInShift;
  const InventoryCloseLineRow({
    required this.id,
    required this.closeId,
    required this.productId,
    required this.systemStock,
    required this.countedStock,
    required this.variance,
    required this.unitsSoldInShift,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['close_id'] = Variable<String>(closeId);
    map['product_id'] = Variable<String>(productId);
    map['system_stock'] = Variable<int>(systemStock);
    map['counted_stock'] = Variable<int>(countedStock);
    map['variance'] = Variable<int>(variance);
    map['units_sold_in_shift'] = Variable<int>(unitsSoldInShift);
    return map;
  }

  InventoryCloseLinesCompanion toCompanion(bool nullToAbsent) {
    return InventoryCloseLinesCompanion(
      id: Value(id),
      closeId: Value(closeId),
      productId: Value(productId),
      systemStock: Value(systemStock),
      countedStock: Value(countedStock),
      variance: Value(variance),
      unitsSoldInShift: Value(unitsSoldInShift),
    );
  }

  factory InventoryCloseLineRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryCloseLineRow(
      id: serializer.fromJson<String>(json['id']),
      closeId: serializer.fromJson<String>(json['closeId']),
      productId: serializer.fromJson<String>(json['productId']),
      systemStock: serializer.fromJson<int>(json['systemStock']),
      countedStock: serializer.fromJson<int>(json['countedStock']),
      variance: serializer.fromJson<int>(json['variance']),
      unitsSoldInShift: serializer.fromJson<int>(json['unitsSoldInShift']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'closeId': serializer.toJson<String>(closeId),
      'productId': serializer.toJson<String>(productId),
      'systemStock': serializer.toJson<int>(systemStock),
      'countedStock': serializer.toJson<int>(countedStock),
      'variance': serializer.toJson<int>(variance),
      'unitsSoldInShift': serializer.toJson<int>(unitsSoldInShift),
    };
  }

  InventoryCloseLineRow copyWith({
    String? id,
    String? closeId,
    String? productId,
    int? systemStock,
    int? countedStock,
    int? variance,
    int? unitsSoldInShift,
  }) => InventoryCloseLineRow(
    id: id ?? this.id,
    closeId: closeId ?? this.closeId,
    productId: productId ?? this.productId,
    systemStock: systemStock ?? this.systemStock,
    countedStock: countedStock ?? this.countedStock,
    variance: variance ?? this.variance,
    unitsSoldInShift: unitsSoldInShift ?? this.unitsSoldInShift,
  );
  InventoryCloseLineRow copyWithCompanion(InventoryCloseLinesCompanion data) {
    return InventoryCloseLineRow(
      id: data.id.present ? data.id.value : this.id,
      closeId: data.closeId.present ? data.closeId.value : this.closeId,
      productId: data.productId.present ? data.productId.value : this.productId,
      systemStock: data.systemStock.present
          ? data.systemStock.value
          : this.systemStock,
      countedStock: data.countedStock.present
          ? data.countedStock.value
          : this.countedStock,
      variance: data.variance.present ? data.variance.value : this.variance,
      unitsSoldInShift: data.unitsSoldInShift.present
          ? data.unitsSoldInShift.value
          : this.unitsSoldInShift,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryCloseLineRow(')
          ..write('id: $id, ')
          ..write('closeId: $closeId, ')
          ..write('productId: $productId, ')
          ..write('systemStock: $systemStock, ')
          ..write('countedStock: $countedStock, ')
          ..write('variance: $variance, ')
          ..write('unitsSoldInShift: $unitsSoldInShift')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    closeId,
    productId,
    systemStock,
    countedStock,
    variance,
    unitsSoldInShift,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryCloseLineRow &&
          other.id == this.id &&
          other.closeId == this.closeId &&
          other.productId == this.productId &&
          other.systemStock == this.systemStock &&
          other.countedStock == this.countedStock &&
          other.variance == this.variance &&
          other.unitsSoldInShift == this.unitsSoldInShift);
}

class InventoryCloseLinesCompanion
    extends UpdateCompanion<InventoryCloseLineRow> {
  final Value<String> id;
  final Value<String> closeId;
  final Value<String> productId;
  final Value<int> systemStock;
  final Value<int> countedStock;
  final Value<int> variance;
  final Value<int> unitsSoldInShift;
  final Value<int> rowid;
  const InventoryCloseLinesCompanion({
    this.id = const Value.absent(),
    this.closeId = const Value.absent(),
    this.productId = const Value.absent(),
    this.systemStock = const Value.absent(),
    this.countedStock = const Value.absent(),
    this.variance = const Value.absent(),
    this.unitsSoldInShift = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InventoryCloseLinesCompanion.insert({
    required String id,
    required String closeId,
    required String productId,
    required int systemStock,
    required int countedStock,
    required int variance,
    required int unitsSoldInShift,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       closeId = Value(closeId),
       productId = Value(productId),
       systemStock = Value(systemStock),
       countedStock = Value(countedStock),
       variance = Value(variance),
       unitsSoldInShift = Value(unitsSoldInShift);
  static Insertable<InventoryCloseLineRow> custom({
    Expression<String>? id,
    Expression<String>? closeId,
    Expression<String>? productId,
    Expression<int>? systemStock,
    Expression<int>? countedStock,
    Expression<int>? variance,
    Expression<int>? unitsSoldInShift,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (closeId != null) 'close_id': closeId,
      if (productId != null) 'product_id': productId,
      if (systemStock != null) 'system_stock': systemStock,
      if (countedStock != null) 'counted_stock': countedStock,
      if (variance != null) 'variance': variance,
      if (unitsSoldInShift != null) 'units_sold_in_shift': unitsSoldInShift,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InventoryCloseLinesCompanion copyWith({
    Value<String>? id,
    Value<String>? closeId,
    Value<String>? productId,
    Value<int>? systemStock,
    Value<int>? countedStock,
    Value<int>? variance,
    Value<int>? unitsSoldInShift,
    Value<int>? rowid,
  }) {
    return InventoryCloseLinesCompanion(
      id: id ?? this.id,
      closeId: closeId ?? this.closeId,
      productId: productId ?? this.productId,
      systemStock: systemStock ?? this.systemStock,
      countedStock: countedStock ?? this.countedStock,
      variance: variance ?? this.variance,
      unitsSoldInShift: unitsSoldInShift ?? this.unitsSoldInShift,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (closeId.present) {
      map['close_id'] = Variable<String>(closeId.value);
    }
    if (productId.present) {
      map['product_id'] = Variable<String>(productId.value);
    }
    if (systemStock.present) {
      map['system_stock'] = Variable<int>(systemStock.value);
    }
    if (countedStock.present) {
      map['counted_stock'] = Variable<int>(countedStock.value);
    }
    if (variance.present) {
      map['variance'] = Variable<int>(variance.value);
    }
    if (unitsSoldInShift.present) {
      map['units_sold_in_shift'] = Variable<int>(unitsSoldInShift.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryCloseLinesCompanion(')
          ..write('id: $id, ')
          ..write('closeId: $closeId, ')
          ..write('productId: $productId, ')
          ..write('systemStock: $systemStock, ')
          ..write('countedStock: $countedStock, ')
          ..write('variance: $variance, ')
          ..write('unitsSoldInShift: $unitsSoldInShift, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductExchangesTable extends ProductExchanges
    with TableInfo<$ProductExchangesTable, ProductExchangeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductExchangesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _originalSaleIdMeta = const VerificationMeta(
    'originalSaleId',
  );
  @override
  late final GeneratedColumn<String> originalSaleId = GeneratedColumn<String>(
    'original_sale_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _returnProductIdMeta = const VerificationMeta(
    'returnProductId',
  );
  @override
  late final GeneratedColumn<String> returnProductId = GeneratedColumn<String>(
    'return_product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _returnQuantityMeta = const VerificationMeta(
    'returnQuantity',
  );
  @override
  late final GeneratedColumn<int> returnQuantity = GeneratedColumn<int>(
    'return_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalUnitPriceClpMeta =
      const VerificationMeta('originalUnitPriceClp');
  @override
  late final GeneratedColumn<int> originalUnitPriceClp = GeneratedColumn<int>(
    'original_unit_price_clp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _newProductIdMeta = const VerificationMeta(
    'newProductId',
  );
  @override
  late final GeneratedColumn<String> newProductId = GeneratedColumn<String>(
    'new_product_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _newQuantityMeta = const VerificationMeta(
    'newQuantity',
  );
  @override
  late final GeneratedColumn<int> newQuantity = GeneratedColumn<int>(
    'new_quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _newUnitPriceClpMeta = const VerificationMeta(
    'newUnitPriceClp',
  );
  @override
  late final GeneratedColumn<int> newUnitPriceClp = GeneratedColumn<int>(
    'new_unit_price_clp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creditClpMeta = const VerificationMeta(
    'creditClp',
  );
  @override
  late final GeneratedColumn<int> creditClp = GeneratedColumn<int>(
    'credit_clp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chargeClpMeta = const VerificationMeta(
    'chargeClp',
  );
  @override
  late final GeneratedColumn<int> chargeClp = GeneratedColumn<int>(
    'charge_clp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _differenceClpMeta = const VerificationMeta(
    'differenceClp',
  );
  @override
  late final GeneratedColumn<int> differenceClp = GeneratedColumn<int>(
    'difference_clp',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _newSaleIdMeta = const VerificationMeta(
    'newSaleId',
  );
  @override
  late final GeneratedColumn<String> newSaleId = GeneratedColumn<String>(
    'new_sale_id',
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
  static const VerificationMeta _actorUserIdMeta = const VerificationMeta(
    'actorUserId',
  );
  @override
  late final GeneratedColumn<String> actorUserId = GeneratedColumn<String>(
    'actor_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _differencePaymentMethodMeta =
      const VerificationMeta('differencePaymentMethod');
  @override
  late final GeneratedColumn<String> differencePaymentMethod =
      GeneratedColumn<String>(
        'difference_payment_method',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _differencePaymentAmountClpMeta =
      const VerificationMeta('differencePaymentAmountClp');
  @override
  late final GeneratedColumn<int> differencePaymentAmountClp =
      GeneratedColumn<int>(
        'difference_payment_amount_clp',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _creditNoteIdMeta = const VerificationMeta(
    'creditNoteId',
  );
  @override
  late final GeneratedColumn<String> creditNoteId = GeneratedColumn<String>(
    'credit_note_id',
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
    originalSaleId,
    returnProductId,
    returnQuantity,
    originalUnitPriceClp,
    newProductId,
    newQuantity,
    newUnitPriceClp,
    creditClp,
    chargeClp,
    differenceClp,
    newSaleId,
    createdAt,
    actorUserId,
    differencePaymentMethod,
    differencePaymentAmountClp,
    creditNoteId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_exchanges';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductExchangeRow> instance, {
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
    if (data.containsKey('original_sale_id')) {
      context.handle(
        _originalSaleIdMeta,
        originalSaleId.isAcceptableOrUnknown(
          data['original_sale_id']!,
          _originalSaleIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalSaleIdMeta);
    }
    if (data.containsKey('return_product_id')) {
      context.handle(
        _returnProductIdMeta,
        returnProductId.isAcceptableOrUnknown(
          data['return_product_id']!,
          _returnProductIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_returnProductIdMeta);
    }
    if (data.containsKey('return_quantity')) {
      context.handle(
        _returnQuantityMeta,
        returnQuantity.isAcceptableOrUnknown(
          data['return_quantity']!,
          _returnQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_returnQuantityMeta);
    }
    if (data.containsKey('original_unit_price_clp')) {
      context.handle(
        _originalUnitPriceClpMeta,
        originalUnitPriceClp.isAcceptableOrUnknown(
          data['original_unit_price_clp']!,
          _originalUnitPriceClpMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalUnitPriceClpMeta);
    }
    if (data.containsKey('new_product_id')) {
      context.handle(
        _newProductIdMeta,
        newProductId.isAcceptableOrUnknown(
          data['new_product_id']!,
          _newProductIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_newProductIdMeta);
    }
    if (data.containsKey('new_quantity')) {
      context.handle(
        _newQuantityMeta,
        newQuantity.isAcceptableOrUnknown(
          data['new_quantity']!,
          _newQuantityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_newQuantityMeta);
    }
    if (data.containsKey('new_unit_price_clp')) {
      context.handle(
        _newUnitPriceClpMeta,
        newUnitPriceClp.isAcceptableOrUnknown(
          data['new_unit_price_clp']!,
          _newUnitPriceClpMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_newUnitPriceClpMeta);
    }
    if (data.containsKey('credit_clp')) {
      context.handle(
        _creditClpMeta,
        creditClp.isAcceptableOrUnknown(data['credit_clp']!, _creditClpMeta),
      );
    } else if (isInserting) {
      context.missing(_creditClpMeta);
    }
    if (data.containsKey('charge_clp')) {
      context.handle(
        _chargeClpMeta,
        chargeClp.isAcceptableOrUnknown(data['charge_clp']!, _chargeClpMeta),
      );
    } else if (isInserting) {
      context.missing(_chargeClpMeta);
    }
    if (data.containsKey('difference_clp')) {
      context.handle(
        _differenceClpMeta,
        differenceClp.isAcceptableOrUnknown(
          data['difference_clp']!,
          _differenceClpMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_differenceClpMeta);
    }
    if (data.containsKey('new_sale_id')) {
      context.handle(
        _newSaleIdMeta,
        newSaleId.isAcceptableOrUnknown(data['new_sale_id']!, _newSaleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_newSaleIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('actor_user_id')) {
      context.handle(
        _actorUserIdMeta,
        actorUserId.isAcceptableOrUnknown(
          data['actor_user_id']!,
          _actorUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actorUserIdMeta);
    }
    if (data.containsKey('difference_payment_method')) {
      context.handle(
        _differencePaymentMethodMeta,
        differencePaymentMethod.isAcceptableOrUnknown(
          data['difference_payment_method']!,
          _differencePaymentMethodMeta,
        ),
      );
    }
    if (data.containsKey('difference_payment_amount_clp')) {
      context.handle(
        _differencePaymentAmountClpMeta,
        differencePaymentAmountClp.isAcceptableOrUnknown(
          data['difference_payment_amount_clp']!,
          _differencePaymentAmountClpMeta,
        ),
      );
    }
    if (data.containsKey('credit_note_id')) {
      context.handle(
        _creditNoteIdMeta,
        creditNoteId.isAcceptableOrUnknown(
          data['credit_note_id']!,
          _creditNoteIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductExchangeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductExchangeRow(
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
      originalSaleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_sale_id'],
      )!,
      returnProductId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}return_product_id'],
      )!,
      returnQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}return_quantity'],
      )!,
      originalUnitPriceClp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}original_unit_price_clp'],
      )!,
      newProductId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}new_product_id'],
      )!,
      newQuantity: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}new_quantity'],
      )!,
      newUnitPriceClp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}new_unit_price_clp'],
      )!,
      creditClp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credit_clp'],
      )!,
      chargeClp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}charge_clp'],
      )!,
      differenceClp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difference_clp'],
      )!,
      newSaleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}new_sale_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      actorUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor_user_id'],
      )!,
      differencePaymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difference_payment_method'],
      ),
      differencePaymentAmountClp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difference_payment_amount_clp'],
      ),
      creditNoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}credit_note_id'],
      ),
    );
  }

  @override
  $ProductExchangesTable createAlias(String alias) {
    return $ProductExchangesTable(attachedDatabase, alias);
  }
}

class ProductExchangeRow extends DataClass
    implements Insertable<ProductExchangeRow> {
  final String id;
  final String storeId;
  final String shiftId;
  final String originalSaleId;
  final String returnProductId;
  final int returnQuantity;
  final int originalUnitPriceClp;
  final String newProductId;
  final int newQuantity;
  final int newUnitPriceClp;
  final int creditClp;
  final int chargeClp;
  final int differenceClp;
  final String newSaleId;
  final String createdAt;
  final String actorUserId;
  final String? differencePaymentMethod;
  final int? differencePaymentAmountClp;
  final String? creditNoteId;
  const ProductExchangeRow({
    required this.id,
    required this.storeId,
    required this.shiftId,
    required this.originalSaleId,
    required this.returnProductId,
    required this.returnQuantity,
    required this.originalUnitPriceClp,
    required this.newProductId,
    required this.newQuantity,
    required this.newUnitPriceClp,
    required this.creditClp,
    required this.chargeClp,
    required this.differenceClp,
    required this.newSaleId,
    required this.createdAt,
    required this.actorUserId,
    this.differencePaymentMethod,
    this.differencePaymentAmountClp,
    this.creditNoteId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['shift_id'] = Variable<String>(shiftId);
    map['original_sale_id'] = Variable<String>(originalSaleId);
    map['return_product_id'] = Variable<String>(returnProductId);
    map['return_quantity'] = Variable<int>(returnQuantity);
    map['original_unit_price_clp'] = Variable<int>(originalUnitPriceClp);
    map['new_product_id'] = Variable<String>(newProductId);
    map['new_quantity'] = Variable<int>(newQuantity);
    map['new_unit_price_clp'] = Variable<int>(newUnitPriceClp);
    map['credit_clp'] = Variable<int>(creditClp);
    map['charge_clp'] = Variable<int>(chargeClp);
    map['difference_clp'] = Variable<int>(differenceClp);
    map['new_sale_id'] = Variable<String>(newSaleId);
    map['created_at'] = Variable<String>(createdAt);
    map['actor_user_id'] = Variable<String>(actorUserId);
    if (!nullToAbsent || differencePaymentMethod != null) {
      map['difference_payment_method'] = Variable<String>(
        differencePaymentMethod,
      );
    }
    if (!nullToAbsent || differencePaymentAmountClp != null) {
      map['difference_payment_amount_clp'] = Variable<int>(
        differencePaymentAmountClp,
      );
    }
    if (!nullToAbsent || creditNoteId != null) {
      map['credit_note_id'] = Variable<String>(creditNoteId);
    }
    return map;
  }

  ProductExchangesCompanion toCompanion(bool nullToAbsent) {
    return ProductExchangesCompanion(
      id: Value(id),
      storeId: Value(storeId),
      shiftId: Value(shiftId),
      originalSaleId: Value(originalSaleId),
      returnProductId: Value(returnProductId),
      returnQuantity: Value(returnQuantity),
      originalUnitPriceClp: Value(originalUnitPriceClp),
      newProductId: Value(newProductId),
      newQuantity: Value(newQuantity),
      newUnitPriceClp: Value(newUnitPriceClp),
      creditClp: Value(creditClp),
      chargeClp: Value(chargeClp),
      differenceClp: Value(differenceClp),
      newSaleId: Value(newSaleId),
      createdAt: Value(createdAt),
      actorUserId: Value(actorUserId),
      differencePaymentMethod: differencePaymentMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(differencePaymentMethod),
      differencePaymentAmountClp:
          differencePaymentAmountClp == null && nullToAbsent
          ? const Value.absent()
          : Value(differencePaymentAmountClp),
      creditNoteId: creditNoteId == null && nullToAbsent
          ? const Value.absent()
          : Value(creditNoteId),
    );
  }

  factory ProductExchangeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductExchangeRow(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      shiftId: serializer.fromJson<String>(json['shiftId']),
      originalSaleId: serializer.fromJson<String>(json['originalSaleId']),
      returnProductId: serializer.fromJson<String>(json['returnProductId']),
      returnQuantity: serializer.fromJson<int>(json['returnQuantity']),
      originalUnitPriceClp: serializer.fromJson<int>(
        json['originalUnitPriceClp'],
      ),
      newProductId: serializer.fromJson<String>(json['newProductId']),
      newQuantity: serializer.fromJson<int>(json['newQuantity']),
      newUnitPriceClp: serializer.fromJson<int>(json['newUnitPriceClp']),
      creditClp: serializer.fromJson<int>(json['creditClp']),
      chargeClp: serializer.fromJson<int>(json['chargeClp']),
      differenceClp: serializer.fromJson<int>(json['differenceClp']),
      newSaleId: serializer.fromJson<String>(json['newSaleId']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      actorUserId: serializer.fromJson<String>(json['actorUserId']),
      differencePaymentMethod: serializer.fromJson<String?>(
        json['differencePaymentMethod'],
      ),
      differencePaymentAmountClp: serializer.fromJson<int?>(
        json['differencePaymentAmountClp'],
      ),
      creditNoteId: serializer.fromJson<String?>(json['creditNoteId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'shiftId': serializer.toJson<String>(shiftId),
      'originalSaleId': serializer.toJson<String>(originalSaleId),
      'returnProductId': serializer.toJson<String>(returnProductId),
      'returnQuantity': serializer.toJson<int>(returnQuantity),
      'originalUnitPriceClp': serializer.toJson<int>(originalUnitPriceClp),
      'newProductId': serializer.toJson<String>(newProductId),
      'newQuantity': serializer.toJson<int>(newQuantity),
      'newUnitPriceClp': serializer.toJson<int>(newUnitPriceClp),
      'creditClp': serializer.toJson<int>(creditClp),
      'chargeClp': serializer.toJson<int>(chargeClp),
      'differenceClp': serializer.toJson<int>(differenceClp),
      'newSaleId': serializer.toJson<String>(newSaleId),
      'createdAt': serializer.toJson<String>(createdAt),
      'actorUserId': serializer.toJson<String>(actorUserId),
      'differencePaymentMethod': serializer.toJson<String?>(
        differencePaymentMethod,
      ),
      'differencePaymentAmountClp': serializer.toJson<int?>(
        differencePaymentAmountClp,
      ),
      'creditNoteId': serializer.toJson<String?>(creditNoteId),
    };
  }

  ProductExchangeRow copyWith({
    String? id,
    String? storeId,
    String? shiftId,
    String? originalSaleId,
    String? returnProductId,
    int? returnQuantity,
    int? originalUnitPriceClp,
    String? newProductId,
    int? newQuantity,
    int? newUnitPriceClp,
    int? creditClp,
    int? chargeClp,
    int? differenceClp,
    String? newSaleId,
    String? createdAt,
    String? actorUserId,
    Value<String?> differencePaymentMethod = const Value.absent(),
    Value<int?> differencePaymentAmountClp = const Value.absent(),
    Value<String?> creditNoteId = const Value.absent(),
  }) => ProductExchangeRow(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    shiftId: shiftId ?? this.shiftId,
    originalSaleId: originalSaleId ?? this.originalSaleId,
    returnProductId: returnProductId ?? this.returnProductId,
    returnQuantity: returnQuantity ?? this.returnQuantity,
    originalUnitPriceClp: originalUnitPriceClp ?? this.originalUnitPriceClp,
    newProductId: newProductId ?? this.newProductId,
    newQuantity: newQuantity ?? this.newQuantity,
    newUnitPriceClp: newUnitPriceClp ?? this.newUnitPriceClp,
    creditClp: creditClp ?? this.creditClp,
    chargeClp: chargeClp ?? this.chargeClp,
    differenceClp: differenceClp ?? this.differenceClp,
    newSaleId: newSaleId ?? this.newSaleId,
    createdAt: createdAt ?? this.createdAt,
    actorUserId: actorUserId ?? this.actorUserId,
    differencePaymentMethod: differencePaymentMethod.present
        ? differencePaymentMethod.value
        : this.differencePaymentMethod,
    differencePaymentAmountClp: differencePaymentAmountClp.present
        ? differencePaymentAmountClp.value
        : this.differencePaymentAmountClp,
    creditNoteId: creditNoteId.present ? creditNoteId.value : this.creditNoteId,
  );
  ProductExchangeRow copyWithCompanion(ProductExchangesCompanion data) {
    return ProductExchangeRow(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      originalSaleId: data.originalSaleId.present
          ? data.originalSaleId.value
          : this.originalSaleId,
      returnProductId: data.returnProductId.present
          ? data.returnProductId.value
          : this.returnProductId,
      returnQuantity: data.returnQuantity.present
          ? data.returnQuantity.value
          : this.returnQuantity,
      originalUnitPriceClp: data.originalUnitPriceClp.present
          ? data.originalUnitPriceClp.value
          : this.originalUnitPriceClp,
      newProductId: data.newProductId.present
          ? data.newProductId.value
          : this.newProductId,
      newQuantity: data.newQuantity.present
          ? data.newQuantity.value
          : this.newQuantity,
      newUnitPriceClp: data.newUnitPriceClp.present
          ? data.newUnitPriceClp.value
          : this.newUnitPriceClp,
      creditClp: data.creditClp.present ? data.creditClp.value : this.creditClp,
      chargeClp: data.chargeClp.present ? data.chargeClp.value : this.chargeClp,
      differenceClp: data.differenceClp.present
          ? data.differenceClp.value
          : this.differenceClp,
      newSaleId: data.newSaleId.present ? data.newSaleId.value : this.newSaleId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      actorUserId: data.actorUserId.present
          ? data.actorUserId.value
          : this.actorUserId,
      differencePaymentMethod: data.differencePaymentMethod.present
          ? data.differencePaymentMethod.value
          : this.differencePaymentMethod,
      differencePaymentAmountClp: data.differencePaymentAmountClp.present
          ? data.differencePaymentAmountClp.value
          : this.differencePaymentAmountClp,
      creditNoteId: data.creditNoteId.present
          ? data.creditNoteId.value
          : this.creditNoteId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductExchangeRow(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('shiftId: $shiftId, ')
          ..write('originalSaleId: $originalSaleId, ')
          ..write('returnProductId: $returnProductId, ')
          ..write('returnQuantity: $returnQuantity, ')
          ..write('originalUnitPriceClp: $originalUnitPriceClp, ')
          ..write('newProductId: $newProductId, ')
          ..write('newQuantity: $newQuantity, ')
          ..write('newUnitPriceClp: $newUnitPriceClp, ')
          ..write('creditClp: $creditClp, ')
          ..write('chargeClp: $chargeClp, ')
          ..write('differenceClp: $differenceClp, ')
          ..write('newSaleId: $newSaleId, ')
          ..write('createdAt: $createdAt, ')
          ..write('actorUserId: $actorUserId, ')
          ..write('differencePaymentMethod: $differencePaymentMethod, ')
          ..write('differencePaymentAmountClp: $differencePaymentAmountClp, ')
          ..write('creditNoteId: $creditNoteId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    shiftId,
    originalSaleId,
    returnProductId,
    returnQuantity,
    originalUnitPriceClp,
    newProductId,
    newQuantity,
    newUnitPriceClp,
    creditClp,
    chargeClp,
    differenceClp,
    newSaleId,
    createdAt,
    actorUserId,
    differencePaymentMethod,
    differencePaymentAmountClp,
    creditNoteId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductExchangeRow &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.shiftId == this.shiftId &&
          other.originalSaleId == this.originalSaleId &&
          other.returnProductId == this.returnProductId &&
          other.returnQuantity == this.returnQuantity &&
          other.originalUnitPriceClp == this.originalUnitPriceClp &&
          other.newProductId == this.newProductId &&
          other.newQuantity == this.newQuantity &&
          other.newUnitPriceClp == this.newUnitPriceClp &&
          other.creditClp == this.creditClp &&
          other.chargeClp == this.chargeClp &&
          other.differenceClp == this.differenceClp &&
          other.newSaleId == this.newSaleId &&
          other.createdAt == this.createdAt &&
          other.actorUserId == this.actorUserId &&
          other.differencePaymentMethod == this.differencePaymentMethod &&
          other.differencePaymentAmountClp == this.differencePaymentAmountClp &&
          other.creditNoteId == this.creditNoteId);
}

class ProductExchangesCompanion extends UpdateCompanion<ProductExchangeRow> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<String> shiftId;
  final Value<String> originalSaleId;
  final Value<String> returnProductId;
  final Value<int> returnQuantity;
  final Value<int> originalUnitPriceClp;
  final Value<String> newProductId;
  final Value<int> newQuantity;
  final Value<int> newUnitPriceClp;
  final Value<int> creditClp;
  final Value<int> chargeClp;
  final Value<int> differenceClp;
  final Value<String> newSaleId;
  final Value<String> createdAt;
  final Value<String> actorUserId;
  final Value<String?> differencePaymentMethod;
  final Value<int?> differencePaymentAmountClp;
  final Value<String?> creditNoteId;
  final Value<int> rowid;
  const ProductExchangesCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.originalSaleId = const Value.absent(),
    this.returnProductId = const Value.absent(),
    this.returnQuantity = const Value.absent(),
    this.originalUnitPriceClp = const Value.absent(),
    this.newProductId = const Value.absent(),
    this.newQuantity = const Value.absent(),
    this.newUnitPriceClp = const Value.absent(),
    this.creditClp = const Value.absent(),
    this.chargeClp = const Value.absent(),
    this.differenceClp = const Value.absent(),
    this.newSaleId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.actorUserId = const Value.absent(),
    this.differencePaymentMethod = const Value.absent(),
    this.differencePaymentAmountClp = const Value.absent(),
    this.creditNoteId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductExchangesCompanion.insert({
    required String id,
    required String storeId,
    required String shiftId,
    required String originalSaleId,
    required String returnProductId,
    required int returnQuantity,
    required int originalUnitPriceClp,
    required String newProductId,
    required int newQuantity,
    required int newUnitPriceClp,
    required int creditClp,
    required int chargeClp,
    required int differenceClp,
    required String newSaleId,
    required String createdAt,
    required String actorUserId,
    this.differencePaymentMethod = const Value.absent(),
    this.differencePaymentAmountClp = const Value.absent(),
    this.creditNoteId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       shiftId = Value(shiftId),
       originalSaleId = Value(originalSaleId),
       returnProductId = Value(returnProductId),
       returnQuantity = Value(returnQuantity),
       originalUnitPriceClp = Value(originalUnitPriceClp),
       newProductId = Value(newProductId),
       newQuantity = Value(newQuantity),
       newUnitPriceClp = Value(newUnitPriceClp),
       creditClp = Value(creditClp),
       chargeClp = Value(chargeClp),
       differenceClp = Value(differenceClp),
       newSaleId = Value(newSaleId),
       createdAt = Value(createdAt),
       actorUserId = Value(actorUserId);
  static Insertable<ProductExchangeRow> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<String>? shiftId,
    Expression<String>? originalSaleId,
    Expression<String>? returnProductId,
    Expression<int>? returnQuantity,
    Expression<int>? originalUnitPriceClp,
    Expression<String>? newProductId,
    Expression<int>? newQuantity,
    Expression<int>? newUnitPriceClp,
    Expression<int>? creditClp,
    Expression<int>? chargeClp,
    Expression<int>? differenceClp,
    Expression<String>? newSaleId,
    Expression<String>? createdAt,
    Expression<String>? actorUserId,
    Expression<String>? differencePaymentMethod,
    Expression<int>? differencePaymentAmountClp,
    Expression<String>? creditNoteId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (shiftId != null) 'shift_id': shiftId,
      if (originalSaleId != null) 'original_sale_id': originalSaleId,
      if (returnProductId != null) 'return_product_id': returnProductId,
      if (returnQuantity != null) 'return_quantity': returnQuantity,
      if (originalUnitPriceClp != null)
        'original_unit_price_clp': originalUnitPriceClp,
      if (newProductId != null) 'new_product_id': newProductId,
      if (newQuantity != null) 'new_quantity': newQuantity,
      if (newUnitPriceClp != null) 'new_unit_price_clp': newUnitPriceClp,
      if (creditClp != null) 'credit_clp': creditClp,
      if (chargeClp != null) 'charge_clp': chargeClp,
      if (differenceClp != null) 'difference_clp': differenceClp,
      if (newSaleId != null) 'new_sale_id': newSaleId,
      if (createdAt != null) 'created_at': createdAt,
      if (actorUserId != null) 'actor_user_id': actorUserId,
      if (differencePaymentMethod != null)
        'difference_payment_method': differencePaymentMethod,
      if (differencePaymentAmountClp != null)
        'difference_payment_amount_clp': differencePaymentAmountClp,
      if (creditNoteId != null) 'credit_note_id': creditNoteId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductExchangesCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<String>? shiftId,
    Value<String>? originalSaleId,
    Value<String>? returnProductId,
    Value<int>? returnQuantity,
    Value<int>? originalUnitPriceClp,
    Value<String>? newProductId,
    Value<int>? newQuantity,
    Value<int>? newUnitPriceClp,
    Value<int>? creditClp,
    Value<int>? chargeClp,
    Value<int>? differenceClp,
    Value<String>? newSaleId,
    Value<String>? createdAt,
    Value<String>? actorUserId,
    Value<String?>? differencePaymentMethod,
    Value<int?>? differencePaymentAmountClp,
    Value<String?>? creditNoteId,
    Value<int>? rowid,
  }) {
    return ProductExchangesCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      shiftId: shiftId ?? this.shiftId,
      originalSaleId: originalSaleId ?? this.originalSaleId,
      returnProductId: returnProductId ?? this.returnProductId,
      returnQuantity: returnQuantity ?? this.returnQuantity,
      originalUnitPriceClp: originalUnitPriceClp ?? this.originalUnitPriceClp,
      newProductId: newProductId ?? this.newProductId,
      newQuantity: newQuantity ?? this.newQuantity,
      newUnitPriceClp: newUnitPriceClp ?? this.newUnitPriceClp,
      creditClp: creditClp ?? this.creditClp,
      chargeClp: chargeClp ?? this.chargeClp,
      differenceClp: differenceClp ?? this.differenceClp,
      newSaleId: newSaleId ?? this.newSaleId,
      createdAt: createdAt ?? this.createdAt,
      actorUserId: actorUserId ?? this.actorUserId,
      differencePaymentMethod:
          differencePaymentMethod ?? this.differencePaymentMethod,
      differencePaymentAmountClp:
          differencePaymentAmountClp ?? this.differencePaymentAmountClp,
      creditNoteId: creditNoteId ?? this.creditNoteId,
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
    if (originalSaleId.present) {
      map['original_sale_id'] = Variable<String>(originalSaleId.value);
    }
    if (returnProductId.present) {
      map['return_product_id'] = Variable<String>(returnProductId.value);
    }
    if (returnQuantity.present) {
      map['return_quantity'] = Variable<int>(returnQuantity.value);
    }
    if (originalUnitPriceClp.present) {
      map['original_unit_price_clp'] = Variable<int>(
        originalUnitPriceClp.value,
      );
    }
    if (newProductId.present) {
      map['new_product_id'] = Variable<String>(newProductId.value);
    }
    if (newQuantity.present) {
      map['new_quantity'] = Variable<int>(newQuantity.value);
    }
    if (newUnitPriceClp.present) {
      map['new_unit_price_clp'] = Variable<int>(newUnitPriceClp.value);
    }
    if (creditClp.present) {
      map['credit_clp'] = Variable<int>(creditClp.value);
    }
    if (chargeClp.present) {
      map['charge_clp'] = Variable<int>(chargeClp.value);
    }
    if (differenceClp.present) {
      map['difference_clp'] = Variable<int>(differenceClp.value);
    }
    if (newSaleId.present) {
      map['new_sale_id'] = Variable<String>(newSaleId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (actorUserId.present) {
      map['actor_user_id'] = Variable<String>(actorUserId.value);
    }
    if (differencePaymentMethod.present) {
      map['difference_payment_method'] = Variable<String>(
        differencePaymentMethod.value,
      );
    }
    if (differencePaymentAmountClp.present) {
      map['difference_payment_amount_clp'] = Variable<int>(
        differencePaymentAmountClp.value,
      );
    }
    if (creditNoteId.present) {
      map['credit_note_id'] = Variable<String>(creditNoteId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductExchangesCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('shiftId: $shiftId, ')
          ..write('originalSaleId: $originalSaleId, ')
          ..write('returnProductId: $returnProductId, ')
          ..write('returnQuantity: $returnQuantity, ')
          ..write('originalUnitPriceClp: $originalUnitPriceClp, ')
          ..write('newProductId: $newProductId, ')
          ..write('newQuantity: $newQuantity, ')
          ..write('newUnitPriceClp: $newUnitPriceClp, ')
          ..write('creditClp: $creditClp, ')
          ..write('chargeClp: $chargeClp, ')
          ..write('differenceClp: $differenceClp, ')
          ..write('newSaleId: $newSaleId, ')
          ..write('createdAt: $createdAt, ')
          ..write('actorUserId: $actorUserId, ')
          ..write('differencePaymentMethod: $differencePaymentMethod, ')
          ..write('differencePaymentAmountClp: $differencePaymentAmountClp, ')
          ..write('creditNoteId: $creditNoteId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CreditNotesTable extends CreditNotes
    with TableInfo<$CreditNotesTable, CreditNoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreditNotesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _saleIdMeta = const VerificationMeta('saleId');
  @override
  late final GeneratedColumn<String> saleId = GeneratedColumn<String>(
    'sale_id',
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
  static const VerificationMeta _dteStatusMeta = const VerificationMeta(
    'dteStatus',
  );
  @override
  late final GeneratedColumn<String> dteStatus = GeneratedColumn<String>(
    'dte_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _actorUserIdMeta = const VerificationMeta(
    'actorUserId',
  );
  @override
  late final GeneratedColumn<String> actorUserId = GeneratedColumn<String>(
    'actor_user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referencedSaleFolioMeta =
      const VerificationMeta('referencedSaleFolio');
  @override
  late final GeneratedColumn<int> referencedSaleFolio = GeneratedColumn<int>(
    'referenced_sale_folio',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referencedDocumentTypeMeta =
      const VerificationMeta('referencedDocumentType');
  @override
  late final GeneratedColumn<int> referencedDocumentType = GeneratedColumn<int>(
    'referenced_document_type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    storeId,
    saleId,
    totalClp,
    dteStatus,
    folio,
    pdfUrl,
    createdAt,
    actorUserId,
    referencedSaleFolio,
    referencedDocumentType,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credit_notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<CreditNoteRow> instance, {
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
    if (data.containsKey('sale_id')) {
      context.handle(
        _saleIdMeta,
        saleId.isAcceptableOrUnknown(data['sale_id']!, _saleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_saleIdMeta);
    }
    if (data.containsKey('total_clp')) {
      context.handle(
        _totalClpMeta,
        totalClp.isAcceptableOrUnknown(data['total_clp']!, _totalClpMeta),
      );
    } else if (isInserting) {
      context.missing(_totalClpMeta);
    }
    if (data.containsKey('dte_status')) {
      context.handle(
        _dteStatusMeta,
        dteStatus.isAcceptableOrUnknown(data['dte_status']!, _dteStatusMeta),
      );
    } else if (isInserting) {
      context.missing(_dteStatusMeta);
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
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('actor_user_id')) {
      context.handle(
        _actorUserIdMeta,
        actorUserId.isAcceptableOrUnknown(
          data['actor_user_id']!,
          _actorUserIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_actorUserIdMeta);
    }
    if (data.containsKey('referenced_sale_folio')) {
      context.handle(
        _referencedSaleFolioMeta,
        referencedSaleFolio.isAcceptableOrUnknown(
          data['referenced_sale_folio']!,
          _referencedSaleFolioMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_referencedSaleFolioMeta);
    }
    if (data.containsKey('referenced_document_type')) {
      context.handle(
        _referencedDocumentTypeMeta,
        referencedDocumentType.isAcceptableOrUnknown(
          data['referenced_document_type']!,
          _referencedDocumentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_referencedDocumentTypeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CreditNoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreditNoteRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      saleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sale_id'],
      )!,
      totalClp: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_clp'],
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
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      actorUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}actor_user_id'],
      )!,
      referencedSaleFolio: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}referenced_sale_folio'],
      )!,
      referencedDocumentType: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}referenced_document_type'],
      )!,
    );
  }

  @override
  $CreditNotesTable createAlias(String alias) {
    return $CreditNotesTable(attachedDatabase, alias);
  }
}

class CreditNoteRow extends DataClass implements Insertable<CreditNoteRow> {
  final String id;
  final String storeId;
  final String saleId;
  final int totalClp;
  final String dteStatus;
  final int? folio;
  final String? pdfUrl;
  final String createdAt;
  final String actorUserId;
  final int referencedSaleFolio;
  final int referencedDocumentType;
  const CreditNoteRow({
    required this.id,
    required this.storeId,
    required this.saleId,
    required this.totalClp,
    required this.dteStatus,
    this.folio,
    this.pdfUrl,
    required this.createdAt,
    required this.actorUserId,
    required this.referencedSaleFolio,
    required this.referencedDocumentType,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['store_id'] = Variable<String>(storeId);
    map['sale_id'] = Variable<String>(saleId);
    map['total_clp'] = Variable<int>(totalClp);
    map['dte_status'] = Variable<String>(dteStatus);
    if (!nullToAbsent || folio != null) {
      map['folio'] = Variable<int>(folio);
    }
    if (!nullToAbsent || pdfUrl != null) {
      map['pdf_url'] = Variable<String>(pdfUrl);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['actor_user_id'] = Variable<String>(actorUserId);
    map['referenced_sale_folio'] = Variable<int>(referencedSaleFolio);
    map['referenced_document_type'] = Variable<int>(referencedDocumentType);
    return map;
  }

  CreditNotesCompanion toCompanion(bool nullToAbsent) {
    return CreditNotesCompanion(
      id: Value(id),
      storeId: Value(storeId),
      saleId: Value(saleId),
      totalClp: Value(totalClp),
      dteStatus: Value(dteStatus),
      folio: folio == null && nullToAbsent
          ? const Value.absent()
          : Value(folio),
      pdfUrl: pdfUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(pdfUrl),
      createdAt: Value(createdAt),
      actorUserId: Value(actorUserId),
      referencedSaleFolio: Value(referencedSaleFolio),
      referencedDocumentType: Value(referencedDocumentType),
    );
  }

  factory CreditNoteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreditNoteRow(
      id: serializer.fromJson<String>(json['id']),
      storeId: serializer.fromJson<String>(json['storeId']),
      saleId: serializer.fromJson<String>(json['saleId']),
      totalClp: serializer.fromJson<int>(json['totalClp']),
      dteStatus: serializer.fromJson<String>(json['dteStatus']),
      folio: serializer.fromJson<int?>(json['folio']),
      pdfUrl: serializer.fromJson<String?>(json['pdfUrl']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      actorUserId: serializer.fromJson<String>(json['actorUserId']),
      referencedSaleFolio: serializer.fromJson<int>(
        json['referencedSaleFolio'],
      ),
      referencedDocumentType: serializer.fromJson<int>(
        json['referencedDocumentType'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'storeId': serializer.toJson<String>(storeId),
      'saleId': serializer.toJson<String>(saleId),
      'totalClp': serializer.toJson<int>(totalClp),
      'dteStatus': serializer.toJson<String>(dteStatus),
      'folio': serializer.toJson<int?>(folio),
      'pdfUrl': serializer.toJson<String?>(pdfUrl),
      'createdAt': serializer.toJson<String>(createdAt),
      'actorUserId': serializer.toJson<String>(actorUserId),
      'referencedSaleFolio': serializer.toJson<int>(referencedSaleFolio),
      'referencedDocumentType': serializer.toJson<int>(referencedDocumentType),
    };
  }

  CreditNoteRow copyWith({
    String? id,
    String? storeId,
    String? saleId,
    int? totalClp,
    String? dteStatus,
    Value<int?> folio = const Value.absent(),
    Value<String?> pdfUrl = const Value.absent(),
    String? createdAt,
    String? actorUserId,
    int? referencedSaleFolio,
    int? referencedDocumentType,
  }) => CreditNoteRow(
    id: id ?? this.id,
    storeId: storeId ?? this.storeId,
    saleId: saleId ?? this.saleId,
    totalClp: totalClp ?? this.totalClp,
    dteStatus: dteStatus ?? this.dteStatus,
    folio: folio.present ? folio.value : this.folio,
    pdfUrl: pdfUrl.present ? pdfUrl.value : this.pdfUrl,
    createdAt: createdAt ?? this.createdAt,
    actorUserId: actorUserId ?? this.actorUserId,
    referencedSaleFolio: referencedSaleFolio ?? this.referencedSaleFolio,
    referencedDocumentType:
        referencedDocumentType ?? this.referencedDocumentType,
  );
  CreditNoteRow copyWithCompanion(CreditNotesCompanion data) {
    return CreditNoteRow(
      id: data.id.present ? data.id.value : this.id,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      saleId: data.saleId.present ? data.saleId.value : this.saleId,
      totalClp: data.totalClp.present ? data.totalClp.value : this.totalClp,
      dteStatus: data.dteStatus.present ? data.dteStatus.value : this.dteStatus,
      folio: data.folio.present ? data.folio.value : this.folio,
      pdfUrl: data.pdfUrl.present ? data.pdfUrl.value : this.pdfUrl,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      actorUserId: data.actorUserId.present
          ? data.actorUserId.value
          : this.actorUserId,
      referencedSaleFolio: data.referencedSaleFolio.present
          ? data.referencedSaleFolio.value
          : this.referencedSaleFolio,
      referencedDocumentType: data.referencedDocumentType.present
          ? data.referencedDocumentType.value
          : this.referencedDocumentType,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CreditNoteRow(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('saleId: $saleId, ')
          ..write('totalClp: $totalClp, ')
          ..write('dteStatus: $dteStatus, ')
          ..write('folio: $folio, ')
          ..write('pdfUrl: $pdfUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('actorUserId: $actorUserId, ')
          ..write('referencedSaleFolio: $referencedSaleFolio, ')
          ..write('referencedDocumentType: $referencedDocumentType')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    storeId,
    saleId,
    totalClp,
    dteStatus,
    folio,
    pdfUrl,
    createdAt,
    actorUserId,
    referencedSaleFolio,
    referencedDocumentType,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreditNoteRow &&
          other.id == this.id &&
          other.storeId == this.storeId &&
          other.saleId == this.saleId &&
          other.totalClp == this.totalClp &&
          other.dteStatus == this.dteStatus &&
          other.folio == this.folio &&
          other.pdfUrl == this.pdfUrl &&
          other.createdAt == this.createdAt &&
          other.actorUserId == this.actorUserId &&
          other.referencedSaleFolio == this.referencedSaleFolio &&
          other.referencedDocumentType == this.referencedDocumentType);
}

class CreditNotesCompanion extends UpdateCompanion<CreditNoteRow> {
  final Value<String> id;
  final Value<String> storeId;
  final Value<String> saleId;
  final Value<int> totalClp;
  final Value<String> dteStatus;
  final Value<int?> folio;
  final Value<String?> pdfUrl;
  final Value<String> createdAt;
  final Value<String> actorUserId;
  final Value<int> referencedSaleFolio;
  final Value<int> referencedDocumentType;
  final Value<int> rowid;
  const CreditNotesCompanion({
    this.id = const Value.absent(),
    this.storeId = const Value.absent(),
    this.saleId = const Value.absent(),
    this.totalClp = const Value.absent(),
    this.dteStatus = const Value.absent(),
    this.folio = const Value.absent(),
    this.pdfUrl = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.actorUserId = const Value.absent(),
    this.referencedSaleFolio = const Value.absent(),
    this.referencedDocumentType = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CreditNotesCompanion.insert({
    required String id,
    required String storeId,
    required String saleId,
    required int totalClp,
    required String dteStatus,
    this.folio = const Value.absent(),
    this.pdfUrl = const Value.absent(),
    required String createdAt,
    required String actorUserId,
    required int referencedSaleFolio,
    required int referencedDocumentType,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       storeId = Value(storeId),
       saleId = Value(saleId),
       totalClp = Value(totalClp),
       dteStatus = Value(dteStatus),
       createdAt = Value(createdAt),
       actorUserId = Value(actorUserId),
       referencedSaleFolio = Value(referencedSaleFolio),
       referencedDocumentType = Value(referencedDocumentType);
  static Insertable<CreditNoteRow> custom({
    Expression<String>? id,
    Expression<String>? storeId,
    Expression<String>? saleId,
    Expression<int>? totalClp,
    Expression<String>? dteStatus,
    Expression<int>? folio,
    Expression<String>? pdfUrl,
    Expression<String>? createdAt,
    Expression<String>? actorUserId,
    Expression<int>? referencedSaleFolio,
    Expression<int>? referencedDocumentType,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (storeId != null) 'store_id': storeId,
      if (saleId != null) 'sale_id': saleId,
      if (totalClp != null) 'total_clp': totalClp,
      if (dteStatus != null) 'dte_status': dteStatus,
      if (folio != null) 'folio': folio,
      if (pdfUrl != null) 'pdf_url': pdfUrl,
      if (createdAt != null) 'created_at': createdAt,
      if (actorUserId != null) 'actor_user_id': actorUserId,
      if (referencedSaleFolio != null)
        'referenced_sale_folio': referencedSaleFolio,
      if (referencedDocumentType != null)
        'referenced_document_type': referencedDocumentType,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CreditNotesCompanion copyWith({
    Value<String>? id,
    Value<String>? storeId,
    Value<String>? saleId,
    Value<int>? totalClp,
    Value<String>? dteStatus,
    Value<int?>? folio,
    Value<String?>? pdfUrl,
    Value<String>? createdAt,
    Value<String>? actorUserId,
    Value<int>? referencedSaleFolio,
    Value<int>? referencedDocumentType,
    Value<int>? rowid,
  }) {
    return CreditNotesCompanion(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      saleId: saleId ?? this.saleId,
      totalClp: totalClp ?? this.totalClp,
      dteStatus: dteStatus ?? this.dteStatus,
      folio: folio ?? this.folio,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      createdAt: createdAt ?? this.createdAt,
      actorUserId: actorUserId ?? this.actorUserId,
      referencedSaleFolio: referencedSaleFolio ?? this.referencedSaleFolio,
      referencedDocumentType:
          referencedDocumentType ?? this.referencedDocumentType,
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
    if (saleId.present) {
      map['sale_id'] = Variable<String>(saleId.value);
    }
    if (totalClp.present) {
      map['total_clp'] = Variable<int>(totalClp.value);
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
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (actorUserId.present) {
      map['actor_user_id'] = Variable<String>(actorUserId.value);
    }
    if (referencedSaleFolio.present) {
      map['referenced_sale_folio'] = Variable<int>(referencedSaleFolio.value);
    }
    if (referencedDocumentType.present) {
      map['referenced_document_type'] = Variable<int>(
        referencedDocumentType.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CreditNotesCompanion(')
          ..write('id: $id, ')
          ..write('storeId: $storeId, ')
          ..write('saleId: $saleId, ')
          ..write('totalClp: $totalClp, ')
          ..write('dteStatus: $dteStatus, ')
          ..write('folio: $folio, ')
          ..write('pdfUrl: $pdfUrl, ')
          ..write('createdAt: $createdAt, ')
          ..write('actorUserId: $actorUserId, ')
          ..write('referencedSaleFolio: $referencedSaleFolio, ')
          ..write('referencedDocumentType: $referencedDocumentType, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CreditNoteLinesTable extends CreditNoteLines
    with TableInfo<$CreditNoteLinesTable, CreditNoteLineRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CreditNoteLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _creditNoteIdMeta = const VerificationMeta(
    'creditNoteId',
  );
  @override
  late final GeneratedColumn<String> creditNoteId = GeneratedColumn<String>(
    'credit_note_id',
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
    creditNoteId,
    productId,
    productName,
    quantity,
    unitPriceClp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'credit_note_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<CreditNoteLineRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('credit_note_id')) {
      context.handle(
        _creditNoteIdMeta,
        creditNoteId.isAcceptableOrUnknown(
          data['credit_note_id']!,
          _creditNoteIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_creditNoteIdMeta);
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
  CreditNoteLineRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CreditNoteLineRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      creditNoteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}credit_note_id'],
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
  $CreditNoteLinesTable createAlias(String alias) {
    return $CreditNoteLinesTable(attachedDatabase, alias);
  }
}

class CreditNoteLineRow extends DataClass
    implements Insertable<CreditNoteLineRow> {
  final String id;
  final String creditNoteId;
  final String productId;
  final String productName;
  final int quantity;
  final int unitPriceClp;
  const CreditNoteLineRow({
    required this.id,
    required this.creditNoteId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPriceClp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['credit_note_id'] = Variable<String>(creditNoteId);
    map['product_id'] = Variable<String>(productId);
    map['product_name'] = Variable<String>(productName);
    map['quantity'] = Variable<int>(quantity);
    map['unit_price_clp'] = Variable<int>(unitPriceClp);
    return map;
  }

  CreditNoteLinesCompanion toCompanion(bool nullToAbsent) {
    return CreditNoteLinesCompanion(
      id: Value(id),
      creditNoteId: Value(creditNoteId),
      productId: Value(productId),
      productName: Value(productName),
      quantity: Value(quantity),
      unitPriceClp: Value(unitPriceClp),
    );
  }

  factory CreditNoteLineRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CreditNoteLineRow(
      id: serializer.fromJson<String>(json['id']),
      creditNoteId: serializer.fromJson<String>(json['creditNoteId']),
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
      'creditNoteId': serializer.toJson<String>(creditNoteId),
      'productId': serializer.toJson<String>(productId),
      'productName': serializer.toJson<String>(productName),
      'quantity': serializer.toJson<int>(quantity),
      'unitPriceClp': serializer.toJson<int>(unitPriceClp),
    };
  }

  CreditNoteLineRow copyWith({
    String? id,
    String? creditNoteId,
    String? productId,
    String? productName,
    int? quantity,
    int? unitPriceClp,
  }) => CreditNoteLineRow(
    id: id ?? this.id,
    creditNoteId: creditNoteId ?? this.creditNoteId,
    productId: productId ?? this.productId,
    productName: productName ?? this.productName,
    quantity: quantity ?? this.quantity,
    unitPriceClp: unitPriceClp ?? this.unitPriceClp,
  );
  CreditNoteLineRow copyWithCompanion(CreditNoteLinesCompanion data) {
    return CreditNoteLineRow(
      id: data.id.present ? data.id.value : this.id,
      creditNoteId: data.creditNoteId.present
          ? data.creditNoteId.value
          : this.creditNoteId,
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
    return (StringBuffer('CreditNoteLineRow(')
          ..write('id: $id, ')
          ..write('creditNoteId: $creditNoteId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceClp: $unitPriceClp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    creditNoteId,
    productId,
    productName,
    quantity,
    unitPriceClp,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CreditNoteLineRow &&
          other.id == this.id &&
          other.creditNoteId == this.creditNoteId &&
          other.productId == this.productId &&
          other.productName == this.productName &&
          other.quantity == this.quantity &&
          other.unitPriceClp == this.unitPriceClp);
}

class CreditNoteLinesCompanion extends UpdateCompanion<CreditNoteLineRow> {
  final Value<String> id;
  final Value<String> creditNoteId;
  final Value<String> productId;
  final Value<String> productName;
  final Value<int> quantity;
  final Value<int> unitPriceClp;
  final Value<int> rowid;
  const CreditNoteLinesCompanion({
    this.id = const Value.absent(),
    this.creditNoteId = const Value.absent(),
    this.productId = const Value.absent(),
    this.productName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unitPriceClp = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CreditNoteLinesCompanion.insert({
    required String id,
    required String creditNoteId,
    required String productId,
    required String productName,
    required int quantity,
    required int unitPriceClp,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       creditNoteId = Value(creditNoteId),
       productId = Value(productId),
       productName = Value(productName),
       quantity = Value(quantity),
       unitPriceClp = Value(unitPriceClp);
  static Insertable<CreditNoteLineRow> custom({
    Expression<String>? id,
    Expression<String>? creditNoteId,
    Expression<String>? productId,
    Expression<String>? productName,
    Expression<int>? quantity,
    Expression<int>? unitPriceClp,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (creditNoteId != null) 'credit_note_id': creditNoteId,
      if (productId != null) 'product_id': productId,
      if (productName != null) 'product_name': productName,
      if (quantity != null) 'quantity': quantity,
      if (unitPriceClp != null) 'unit_price_clp': unitPriceClp,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CreditNoteLinesCompanion copyWith({
    Value<String>? id,
    Value<String>? creditNoteId,
    Value<String>? productId,
    Value<String>? productName,
    Value<int>? quantity,
    Value<int>? unitPriceClp,
    Value<int>? rowid,
  }) {
    return CreditNoteLinesCompanion(
      id: id ?? this.id,
      creditNoteId: creditNoteId ?? this.creditNoteId,
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
    if (creditNoteId.present) {
      map['credit_note_id'] = Variable<String>(creditNoteId.value);
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
    return (StringBuffer('CreditNoteLinesCompanion(')
          ..write('id: $id, ')
          ..write('creditNoteId: $creditNoteId, ')
          ..write('productId: $productId, ')
          ..write('productName: $productName, ')
          ..write('quantity: $quantity, ')
          ..write('unitPriceClp: $unitPriceClp, ')
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

class $InvoiceCustomersTable extends InvoiceCustomers
    with TableInfo<$InvoiceCustomersTable, InvoiceCustomerRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InvoiceCustomersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _rutMeta = const VerificationMeta('rut');
  @override
  late final GeneratedColumn<String> rut = GeneratedColumn<String>(
    'rut',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _businessNameMeta = const VerificationMeta(
    'businessName',
  );
  @override
  late final GeneratedColumn<String> businessName = GeneratedColumn<String>(
    'business_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _giroMeta = const VerificationMeta('giro');
  @override
  late final GeneratedColumn<String> giro = GeneratedColumn<String>(
    'giro',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _communeMeta = const VerificationMeta(
    'commune',
  );
  @override
  late final GeneratedColumn<String> commune = GeneratedColumn<String>(
    'commune',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    storeId,
    rut,
    businessName,
    giro,
    email,
    address,
    city,
    commune,
    phone,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'invoice_customers';
  @override
  VerificationContext validateIntegrity(
    Insertable<InvoiceCustomerRow> instance, {
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
    if (data.containsKey('rut')) {
      context.handle(
        _rutMeta,
        rut.isAcceptableOrUnknown(data['rut']!, _rutMeta),
      );
    } else if (isInserting) {
      context.missing(_rutMeta);
    }
    if (data.containsKey('business_name')) {
      context.handle(
        _businessNameMeta,
        businessName.isAcceptableOrUnknown(
          data['business_name']!,
          _businessNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_businessNameMeta);
    }
    if (data.containsKey('giro')) {
      context.handle(
        _giroMeta,
        giro.isAcceptableOrUnknown(data['giro']!, _giroMeta),
      );
    } else if (isInserting) {
      context.missing(_giroMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    } else if (isInserting) {
      context.missing(_cityMeta);
    }
    if (data.containsKey('commune')) {
      context.handle(
        _communeMeta,
        commune.isAcceptableOrUnknown(data['commune']!, _communeMeta),
      );
    } else if (isInserting) {
      context.missing(_communeMeta);
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {storeId, rut};
  @override
  InvoiceCustomerRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InvoiceCustomerRow(
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      rut: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rut'],
      )!,
      businessName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}business_name'],
      )!,
      giro: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}giro'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      )!,
      commune: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}commune'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
    );
  }

  @override
  $InvoiceCustomersTable createAlias(String alias) {
    return $InvoiceCustomersTable(attachedDatabase, alias);
  }
}

class InvoiceCustomerRow extends DataClass
    implements Insertable<InvoiceCustomerRow> {
  final String storeId;
  final String rut;
  final String businessName;
  final String giro;
  final String email;
  final String address;
  final String city;
  final String commune;
  final String phone;
  const InvoiceCustomerRow({
    required this.storeId,
    required this.rut,
    required this.businessName,
    required this.giro,
    required this.email,
    required this.address,
    required this.city,
    required this.commune,
    required this.phone,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['store_id'] = Variable<String>(storeId);
    map['rut'] = Variable<String>(rut);
    map['business_name'] = Variable<String>(businessName);
    map['giro'] = Variable<String>(giro);
    map['email'] = Variable<String>(email);
    map['address'] = Variable<String>(address);
    map['city'] = Variable<String>(city);
    map['commune'] = Variable<String>(commune);
    map['phone'] = Variable<String>(phone);
    return map;
  }

  InvoiceCustomersCompanion toCompanion(bool nullToAbsent) {
    return InvoiceCustomersCompanion(
      storeId: Value(storeId),
      rut: Value(rut),
      businessName: Value(businessName),
      giro: Value(giro),
      email: Value(email),
      address: Value(address),
      city: Value(city),
      commune: Value(commune),
      phone: Value(phone),
    );
  }

  factory InvoiceCustomerRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InvoiceCustomerRow(
      storeId: serializer.fromJson<String>(json['storeId']),
      rut: serializer.fromJson<String>(json['rut']),
      businessName: serializer.fromJson<String>(json['businessName']),
      giro: serializer.fromJson<String>(json['giro']),
      email: serializer.fromJson<String>(json['email']),
      address: serializer.fromJson<String>(json['address']),
      city: serializer.fromJson<String>(json['city']),
      commune: serializer.fromJson<String>(json['commune']),
      phone: serializer.fromJson<String>(json['phone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'storeId': serializer.toJson<String>(storeId),
      'rut': serializer.toJson<String>(rut),
      'businessName': serializer.toJson<String>(businessName),
      'giro': serializer.toJson<String>(giro),
      'email': serializer.toJson<String>(email),
      'address': serializer.toJson<String>(address),
      'city': serializer.toJson<String>(city),
      'commune': serializer.toJson<String>(commune),
      'phone': serializer.toJson<String>(phone),
    };
  }

  InvoiceCustomerRow copyWith({
    String? storeId,
    String? rut,
    String? businessName,
    String? giro,
    String? email,
    String? address,
    String? city,
    String? commune,
    String? phone,
  }) => InvoiceCustomerRow(
    storeId: storeId ?? this.storeId,
    rut: rut ?? this.rut,
    businessName: businessName ?? this.businessName,
    giro: giro ?? this.giro,
    email: email ?? this.email,
    address: address ?? this.address,
    city: city ?? this.city,
    commune: commune ?? this.commune,
    phone: phone ?? this.phone,
  );
  InvoiceCustomerRow copyWithCompanion(InvoiceCustomersCompanion data) {
    return InvoiceCustomerRow(
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      rut: data.rut.present ? data.rut.value : this.rut,
      businessName: data.businessName.present
          ? data.businessName.value
          : this.businessName,
      giro: data.giro.present ? data.giro.value : this.giro,
      email: data.email.present ? data.email.value : this.email,
      address: data.address.present ? data.address.value : this.address,
      city: data.city.present ? data.city.value : this.city,
      commune: data.commune.present ? data.commune.value : this.commune,
      phone: data.phone.present ? data.phone.value : this.phone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceCustomerRow(')
          ..write('storeId: $storeId, ')
          ..write('rut: $rut, ')
          ..write('businessName: $businessName, ')
          ..write('giro: $giro, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('commune: $commune, ')
          ..write('phone: $phone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    storeId,
    rut,
    businessName,
    giro,
    email,
    address,
    city,
    commune,
    phone,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InvoiceCustomerRow &&
          other.storeId == this.storeId &&
          other.rut == this.rut &&
          other.businessName == this.businessName &&
          other.giro == this.giro &&
          other.email == this.email &&
          other.address == this.address &&
          other.city == this.city &&
          other.commune == this.commune &&
          other.phone == this.phone);
}

class InvoiceCustomersCompanion extends UpdateCompanion<InvoiceCustomerRow> {
  final Value<String> storeId;
  final Value<String> rut;
  final Value<String> businessName;
  final Value<String> giro;
  final Value<String> email;
  final Value<String> address;
  final Value<String> city;
  final Value<String> commune;
  final Value<String> phone;
  final Value<int> rowid;
  const InvoiceCustomersCompanion({
    this.storeId = const Value.absent(),
    this.rut = const Value.absent(),
    this.businessName = const Value.absent(),
    this.giro = const Value.absent(),
    this.email = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.commune = const Value.absent(),
    this.phone = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InvoiceCustomersCompanion.insert({
    required String storeId,
    required String rut,
    required String businessName,
    required String giro,
    required String email,
    required String address,
    required String city,
    required String commune,
    required String phone,
    this.rowid = const Value.absent(),
  }) : storeId = Value(storeId),
       rut = Value(rut),
       businessName = Value(businessName),
       giro = Value(giro),
       email = Value(email),
       address = Value(address),
       city = Value(city),
       commune = Value(commune),
       phone = Value(phone);
  static Insertable<InvoiceCustomerRow> custom({
    Expression<String>? storeId,
    Expression<String>? rut,
    Expression<String>? businessName,
    Expression<String>? giro,
    Expression<String>? email,
    Expression<String>? address,
    Expression<String>? city,
    Expression<String>? commune,
    Expression<String>? phone,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (storeId != null) 'store_id': storeId,
      if (rut != null) 'rut': rut,
      if (businessName != null) 'business_name': businessName,
      if (giro != null) 'giro': giro,
      if (email != null) 'email': email,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (commune != null) 'commune': commune,
      if (phone != null) 'phone': phone,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InvoiceCustomersCompanion copyWith({
    Value<String>? storeId,
    Value<String>? rut,
    Value<String>? businessName,
    Value<String>? giro,
    Value<String>? email,
    Value<String>? address,
    Value<String>? city,
    Value<String>? commune,
    Value<String>? phone,
    Value<int>? rowid,
  }) {
    return InvoiceCustomersCompanion(
      storeId: storeId ?? this.storeId,
      rut: rut ?? this.rut,
      businessName: businessName ?? this.businessName,
      giro: giro ?? this.giro,
      email: email ?? this.email,
      address: address ?? this.address,
      city: city ?? this.city,
      commune: commune ?? this.commune,
      phone: phone ?? this.phone,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (rut.present) {
      map['rut'] = Variable<String>(rut.value);
    }
    if (businessName.present) {
      map['business_name'] = Variable<String>(businessName.value);
    }
    if (giro.present) {
      map['giro'] = Variable<String>(giro.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (commune.present) {
      map['commune'] = Variable<String>(commune.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InvoiceCustomersCompanion(')
          ..write('storeId: $storeId, ')
          ..write('rut: $rut, ')
          ..write('businessName: $businessName, ')
          ..write('giro: $giro, ')
          ..write('email: $email, ')
          ..write('address: $address, ')
          ..write('city: $city, ')
          ..write('commune: $commune, ')
          ..write('phone: $phone, ')
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
  late final $InventoryClosesTable inventoryCloses = $InventoryClosesTable(
    this,
  );
  late final $InventoryCloseLinesTable inventoryCloseLines =
      $InventoryCloseLinesTable(this);
  late final $ProductExchangesTable productExchanges = $ProductExchangesTable(
    this,
  );
  late final $CreditNotesTable creditNotes = $CreditNotesTable(this);
  late final $CreditNoteLinesTable creditNoteLines = $CreditNoteLinesTable(
    this,
  );
  late final $DteFolioCountersTable dteFolioCounters = $DteFolioCountersTable(
    this,
  );
  late final $ClockStateTable clockState = $ClockStateTable(this);
  late final $InvoiceCustomersTable invoiceCustomers = $InvoiceCustomersTable(
    this,
  );
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
    inventoryCloses,
    inventoryCloseLines,
    productExchanges,
    creditNotes,
    creditNoteLines,
    dteFolioCounters,
    clockState,
    invoiceCustomers,
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
      Value<String> posTemplateId,
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
      Value<String> posTemplateId,
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

  ColumnFilters<String> get posTemplateId => $composableBuilder(
    column: $table.posTemplateId,
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

  ColumnOrderings<String> get posTemplateId => $composableBuilder(
    column: $table.posTemplateId,
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

  GeneratedColumn<String> get posTemplateId => $composableBuilder(
    column: $table.posTemplateId,
    builder: (column) => column,
  );
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
                Value<String> posTemplateId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoresCompanion(
                id: id,
                rut: rut,
                legalName: legalName,
                businessLine: businessLine,
                taxConfig: taxConfig,
                createdAt: createdAt,
                posTemplateId: posTemplateId,
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
                Value<String> posTemplateId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoresCompanion.insert(
                id: id,
                rut: rut,
                legalName: legalName,
                businessLine: businessLine,
                taxConfig: taxConfig,
                createdAt: createdAt,
                posTemplateId: posTemplateId,
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
      Value<int?> lowStockThreshold,
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
      Value<int?> lowStockThreshold,
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

  ColumnFilters<int> get lowStockThreshold => $composableBuilder(
    column: $table.lowStockThreshold,
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

  ColumnOrderings<int> get lowStockThreshold => $composableBuilder(
    column: $table.lowStockThreshold,
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

  GeneratedColumn<int> get lowStockThreshold => $composableBuilder(
    column: $table.lowStockThreshold,
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
                Value<int?> lowStockThreshold = const Value.absent(),
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
                lowStockThreshold: lowStockThreshold,
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
                Value<int?> lowStockThreshold = const Value.absent(),
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
                lowStockThreshold: lowStockThreshold,
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
      Value<String?> guideRef,
      Value<String?> lotRef,
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
      Value<String?> guideRef,
      Value<String?> lotRef,
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

  ColumnFilters<String> get guideRef => $composableBuilder(
    column: $table.guideRef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lotRef => $composableBuilder(
    column: $table.lotRef,
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

  ColumnOrderings<String> get guideRef => $composableBuilder(
    column: $table.guideRef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lotRef => $composableBuilder(
    column: $table.lotRef,
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

  GeneratedColumn<String> get guideRef =>
      $composableBuilder(column: $table.guideRef, builder: (column) => column);

  GeneratedColumn<String> get lotRef =>
      $composableBuilder(column: $table.lotRef, builder: (column) => column);
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
                Value<String?> guideRef = const Value.absent(),
                Value<String?> lotRef = const Value.absent(),
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
                guideRef: guideRef,
                lotRef: lotRef,
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
                Value<String?> guideRef = const Value.absent(),
                Value<String?> lotRef = const Value.absent(),
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
                guideRef: guideRef,
                lotRef: lotRef,
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
      Value<String?> sellerCode,
      Value<String?> voidedAt,
      Value<String?> voidedByUserId,
      Value<int> dteDocumentType,
      Value<String?> invoiceReceiverRut,
      Value<String?> invoiceReceiverName,
      Value<String?> invoiceReceiverGiro,
      Value<String?> invoiceReceiverEmail,
      Value<String?> invoiceReceiverAddress,
      Value<String?> invoiceReceiverCity,
      Value<String?> invoiceReceiverCommune,
      Value<String?> invoiceReceiverPhone,
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
      Value<String?> sellerCode,
      Value<String?> voidedAt,
      Value<String?> voidedByUserId,
      Value<int> dteDocumentType,
      Value<String?> invoiceReceiverRut,
      Value<String?> invoiceReceiverName,
      Value<String?> invoiceReceiverGiro,
      Value<String?> invoiceReceiverEmail,
      Value<String?> invoiceReceiverAddress,
      Value<String?> invoiceReceiverCity,
      Value<String?> invoiceReceiverCommune,
      Value<String?> invoiceReceiverPhone,
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

  ColumnFilters<String> get sellerCode => $composableBuilder(
    column: $table.sellerCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voidedAt => $composableBuilder(
    column: $table.voidedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get voidedByUserId => $composableBuilder(
    column: $table.voidedByUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dteDocumentType => $composableBuilder(
    column: $table.dteDocumentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceReceiverRut => $composableBuilder(
    column: $table.invoiceReceiverRut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceReceiverName => $composableBuilder(
    column: $table.invoiceReceiverName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceReceiverGiro => $composableBuilder(
    column: $table.invoiceReceiverGiro,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceReceiverEmail => $composableBuilder(
    column: $table.invoiceReceiverEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceReceiverAddress => $composableBuilder(
    column: $table.invoiceReceiverAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceReceiverCity => $composableBuilder(
    column: $table.invoiceReceiverCity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceReceiverCommune => $composableBuilder(
    column: $table.invoiceReceiverCommune,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invoiceReceiverPhone => $composableBuilder(
    column: $table.invoiceReceiverPhone,
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

  ColumnOrderings<String> get sellerCode => $composableBuilder(
    column: $table.sellerCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voidedAt => $composableBuilder(
    column: $table.voidedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voidedByUserId => $composableBuilder(
    column: $table.voidedByUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dteDocumentType => $composableBuilder(
    column: $table.dteDocumentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceReceiverRut => $composableBuilder(
    column: $table.invoiceReceiverRut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceReceiverName => $composableBuilder(
    column: $table.invoiceReceiverName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceReceiverGiro => $composableBuilder(
    column: $table.invoiceReceiverGiro,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceReceiverEmail => $composableBuilder(
    column: $table.invoiceReceiverEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceReceiverAddress => $composableBuilder(
    column: $table.invoiceReceiverAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceReceiverCity => $composableBuilder(
    column: $table.invoiceReceiverCity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceReceiverCommune => $composableBuilder(
    column: $table.invoiceReceiverCommune,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invoiceReceiverPhone => $composableBuilder(
    column: $table.invoiceReceiverPhone,
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

  GeneratedColumn<String> get sellerCode => $composableBuilder(
    column: $table.sellerCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get voidedAt =>
      $composableBuilder(column: $table.voidedAt, builder: (column) => column);

  GeneratedColumn<String> get voidedByUserId => $composableBuilder(
    column: $table.voidedByUserId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dteDocumentType => $composableBuilder(
    column: $table.dteDocumentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceReceiverRut => $composableBuilder(
    column: $table.invoiceReceiverRut,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceReceiverName => $composableBuilder(
    column: $table.invoiceReceiverName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceReceiverGiro => $composableBuilder(
    column: $table.invoiceReceiverGiro,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceReceiverEmail => $composableBuilder(
    column: $table.invoiceReceiverEmail,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceReceiverAddress => $composableBuilder(
    column: $table.invoiceReceiverAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceReceiverCity => $composableBuilder(
    column: $table.invoiceReceiverCity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceReceiverCommune => $composableBuilder(
    column: $table.invoiceReceiverCommune,
    builder: (column) => column,
  );

  GeneratedColumn<String> get invoiceReceiverPhone => $composableBuilder(
    column: $table.invoiceReceiverPhone,
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
                Value<String?> sellerCode = const Value.absent(),
                Value<String?> voidedAt = const Value.absent(),
                Value<String?> voidedByUserId = const Value.absent(),
                Value<int> dteDocumentType = const Value.absent(),
                Value<String?> invoiceReceiverRut = const Value.absent(),
                Value<String?> invoiceReceiverName = const Value.absent(),
                Value<String?> invoiceReceiverGiro = const Value.absent(),
                Value<String?> invoiceReceiverEmail = const Value.absent(),
                Value<String?> invoiceReceiverAddress = const Value.absent(),
                Value<String?> invoiceReceiverCity = const Value.absent(),
                Value<String?> invoiceReceiverCommune = const Value.absent(),
                Value<String?> invoiceReceiverPhone = const Value.absent(),
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
                sellerCode: sellerCode,
                voidedAt: voidedAt,
                voidedByUserId: voidedByUserId,
                dteDocumentType: dteDocumentType,
                invoiceReceiverRut: invoiceReceiverRut,
                invoiceReceiverName: invoiceReceiverName,
                invoiceReceiverGiro: invoiceReceiverGiro,
                invoiceReceiverEmail: invoiceReceiverEmail,
                invoiceReceiverAddress: invoiceReceiverAddress,
                invoiceReceiverCity: invoiceReceiverCity,
                invoiceReceiverCommune: invoiceReceiverCommune,
                invoiceReceiverPhone: invoiceReceiverPhone,
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
                Value<String?> sellerCode = const Value.absent(),
                Value<String?> voidedAt = const Value.absent(),
                Value<String?> voidedByUserId = const Value.absent(),
                Value<int> dteDocumentType = const Value.absent(),
                Value<String?> invoiceReceiverRut = const Value.absent(),
                Value<String?> invoiceReceiverName = const Value.absent(),
                Value<String?> invoiceReceiverGiro = const Value.absent(),
                Value<String?> invoiceReceiverEmail = const Value.absent(),
                Value<String?> invoiceReceiverAddress = const Value.absent(),
                Value<String?> invoiceReceiverCity = const Value.absent(),
                Value<String?> invoiceReceiverCommune = const Value.absent(),
                Value<String?> invoiceReceiverPhone = const Value.absent(),
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
                sellerCode: sellerCode,
                voidedAt: voidedAt,
                voidedByUserId: voidedByUserId,
                dteDocumentType: dteDocumentType,
                invoiceReceiverRut: invoiceReceiverRut,
                invoiceReceiverName: invoiceReceiverName,
                invoiceReceiverGiro: invoiceReceiverGiro,
                invoiceReceiverEmail: invoiceReceiverEmail,
                invoiceReceiverAddress: invoiceReceiverAddress,
                invoiceReceiverCity: invoiceReceiverCity,
                invoiceReceiverCommune: invoiceReceiverCommune,
                invoiceReceiverPhone: invoiceReceiverPhone,
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
      required String documentId,
      required String saleId,
      required String storeId,
      Value<int> documentType,
      Value<int> attempts,
      Value<String?> lastError,
      required String createdAt,
      Value<int> rowid,
    });
typedef $$DteQueueTableUpdateCompanionBuilder =
    DteQueueCompanion Function({
      Value<String> documentId,
      Value<String> saleId,
      Value<String> storeId,
      Value<int> documentType,
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
  ColumnFilters<String> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get documentType => $composableBuilder(
    column: $table.documentType,
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
  ColumnOrderings<String> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get documentType => $composableBuilder(
    column: $table.documentType,
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
  GeneratedColumn<String> get documentId => $composableBuilder(
    column: $table.documentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<int> get documentType => $composableBuilder(
    column: $table.documentType,
    builder: (column) => column,
  );

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
                Value<String> documentId = const Value.absent(),
                Value<String> saleId = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<int> documentType = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DteQueueCompanion(
                documentId: documentId,
                saleId: saleId,
                storeId: storeId,
                documentType: documentType,
                attempts: attempts,
                lastError: lastError,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String documentId,
                required String saleId,
                required String storeId,
                Value<int> documentType = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                required String createdAt,
                Value<int> rowid = const Value.absent(),
              }) => DteQueueCompanion.insert(
                documentId: documentId,
                saleId: saleId,
                storeId: storeId,
                documentType: documentType,
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
      required String createdAt,
      Value<String?> createdByUserId,
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
      Value<String> createdAt,
      Value<String?> createdByUserId,
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

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdByUserId => $composableBuilder(
    column: $table.createdByUserId,
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

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdByUserId => $composableBuilder(
    column: $table.createdByUserId,
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

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get createdByUserId => $composableBuilder(
    column: $table.createdByUserId,
    builder: (column) => column,
  );
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
                Value<String> createdAt = const Value.absent(),
                Value<String?> createdByUserId = const Value.absent(),
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
                createdAt: createdAt,
                createdByUserId: createdByUserId,
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
                required String createdAt,
                Value<String?> createdByUserId = const Value.absent(),
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
                createdAt: createdAt,
                createdByUserId: createdByUserId,
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
typedef $$InventoryClosesTableCreateCompanionBuilder =
    InventoryClosesCompanion Function({
      required String id,
      required String storeId,
      required String shiftId,
      required String createdAt,
      required String actorUserId,
      Value<int> rowid,
    });
typedef $$InventoryClosesTableUpdateCompanionBuilder =
    InventoryClosesCompanion Function({
      Value<String> id,
      Value<String> storeId,
      Value<String> shiftId,
      Value<String> createdAt,
      Value<String> actorUserId,
      Value<int> rowid,
    });

class $$InventoryClosesTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryClosesTable> {
  $$InventoryClosesTableFilterComposer({
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

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actorUserId => $composableBuilder(
    column: $table.actorUserId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InventoryClosesTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryClosesTable> {
  $$InventoryClosesTableOrderingComposer({
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

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actorUserId => $composableBuilder(
    column: $table.actorUserId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InventoryClosesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryClosesTable> {
  $$InventoryClosesTableAnnotationComposer({
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

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get actorUserId => $composableBuilder(
    column: $table.actorUserId,
    builder: (column) => column,
  );
}

class $$InventoryClosesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryClosesTable,
          InventoryCloseRow,
          $$InventoryClosesTableFilterComposer,
          $$InventoryClosesTableOrderingComposer,
          $$InventoryClosesTableAnnotationComposer,
          $$InventoryClosesTableCreateCompanionBuilder,
          $$InventoryClosesTableUpdateCompanionBuilder,
          (
            InventoryCloseRow,
            BaseReferences<
              _$AppDatabase,
              $InventoryClosesTable,
              InventoryCloseRow
            >,
          ),
          InventoryCloseRow,
          PrefetchHooks Function()
        > {
  $$InventoryClosesTableTableManager(
    _$AppDatabase db,
    $InventoryClosesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryClosesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryClosesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryClosesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<String> shiftId = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> actorUserId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoryClosesCompanion(
                id: id,
                storeId: storeId,
                shiftId: shiftId,
                createdAt: createdAt,
                actorUserId: actorUserId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required String shiftId,
                required String createdAt,
                required String actorUserId,
                Value<int> rowid = const Value.absent(),
              }) => InventoryClosesCompanion.insert(
                id: id,
                storeId: storeId,
                shiftId: shiftId,
                createdAt: createdAt,
                actorUserId: actorUserId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InventoryClosesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryClosesTable,
      InventoryCloseRow,
      $$InventoryClosesTableFilterComposer,
      $$InventoryClosesTableOrderingComposer,
      $$InventoryClosesTableAnnotationComposer,
      $$InventoryClosesTableCreateCompanionBuilder,
      $$InventoryClosesTableUpdateCompanionBuilder,
      (
        InventoryCloseRow,
        BaseReferences<_$AppDatabase, $InventoryClosesTable, InventoryCloseRow>,
      ),
      InventoryCloseRow,
      PrefetchHooks Function()
    >;
typedef $$InventoryCloseLinesTableCreateCompanionBuilder =
    InventoryCloseLinesCompanion Function({
      required String id,
      required String closeId,
      required String productId,
      required int systemStock,
      required int countedStock,
      required int variance,
      required int unitsSoldInShift,
      Value<int> rowid,
    });
typedef $$InventoryCloseLinesTableUpdateCompanionBuilder =
    InventoryCloseLinesCompanion Function({
      Value<String> id,
      Value<String> closeId,
      Value<String> productId,
      Value<int> systemStock,
      Value<int> countedStock,
      Value<int> variance,
      Value<int> unitsSoldInShift,
      Value<int> rowid,
    });

class $$InventoryCloseLinesTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryCloseLinesTable> {
  $$InventoryCloseLinesTableFilterComposer({
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

  ColumnFilters<String> get closeId => $composableBuilder(
    column: $table.closeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get systemStock => $composableBuilder(
    column: $table.systemStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get countedStock => $composableBuilder(
    column: $table.countedStock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get variance => $composableBuilder(
    column: $table.variance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unitsSoldInShift => $composableBuilder(
    column: $table.unitsSoldInShift,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InventoryCloseLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryCloseLinesTable> {
  $$InventoryCloseLinesTableOrderingComposer({
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

  ColumnOrderings<String> get closeId => $composableBuilder(
    column: $table.closeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get productId => $composableBuilder(
    column: $table.productId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get systemStock => $composableBuilder(
    column: $table.systemStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get countedStock => $composableBuilder(
    column: $table.countedStock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get variance => $composableBuilder(
    column: $table.variance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unitsSoldInShift => $composableBuilder(
    column: $table.unitsSoldInShift,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InventoryCloseLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryCloseLinesTable> {
  $$InventoryCloseLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get closeId =>
      $composableBuilder(column: $table.closeId, builder: (column) => column);

  GeneratedColumn<String> get productId =>
      $composableBuilder(column: $table.productId, builder: (column) => column);

  GeneratedColumn<int> get systemStock => $composableBuilder(
    column: $table.systemStock,
    builder: (column) => column,
  );

  GeneratedColumn<int> get countedStock => $composableBuilder(
    column: $table.countedStock,
    builder: (column) => column,
  );

  GeneratedColumn<int> get variance =>
      $composableBuilder(column: $table.variance, builder: (column) => column);

  GeneratedColumn<int> get unitsSoldInShift => $composableBuilder(
    column: $table.unitsSoldInShift,
    builder: (column) => column,
  );
}

class $$InventoryCloseLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryCloseLinesTable,
          InventoryCloseLineRow,
          $$InventoryCloseLinesTableFilterComposer,
          $$InventoryCloseLinesTableOrderingComposer,
          $$InventoryCloseLinesTableAnnotationComposer,
          $$InventoryCloseLinesTableCreateCompanionBuilder,
          $$InventoryCloseLinesTableUpdateCompanionBuilder,
          (
            InventoryCloseLineRow,
            BaseReferences<
              _$AppDatabase,
              $InventoryCloseLinesTable,
              InventoryCloseLineRow
            >,
          ),
          InventoryCloseLineRow,
          PrefetchHooks Function()
        > {
  $$InventoryCloseLinesTableTableManager(
    _$AppDatabase db,
    $InventoryCloseLinesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryCloseLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryCloseLinesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$InventoryCloseLinesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> closeId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<int> systemStock = const Value.absent(),
                Value<int> countedStock = const Value.absent(),
                Value<int> variance = const Value.absent(),
                Value<int> unitsSoldInShift = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InventoryCloseLinesCompanion(
                id: id,
                closeId: closeId,
                productId: productId,
                systemStock: systemStock,
                countedStock: countedStock,
                variance: variance,
                unitsSoldInShift: unitsSoldInShift,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String closeId,
                required String productId,
                required int systemStock,
                required int countedStock,
                required int variance,
                required int unitsSoldInShift,
                Value<int> rowid = const Value.absent(),
              }) => InventoryCloseLinesCompanion.insert(
                id: id,
                closeId: closeId,
                productId: productId,
                systemStock: systemStock,
                countedStock: countedStock,
                variance: variance,
                unitsSoldInShift: unitsSoldInShift,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InventoryCloseLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryCloseLinesTable,
      InventoryCloseLineRow,
      $$InventoryCloseLinesTableFilterComposer,
      $$InventoryCloseLinesTableOrderingComposer,
      $$InventoryCloseLinesTableAnnotationComposer,
      $$InventoryCloseLinesTableCreateCompanionBuilder,
      $$InventoryCloseLinesTableUpdateCompanionBuilder,
      (
        InventoryCloseLineRow,
        BaseReferences<
          _$AppDatabase,
          $InventoryCloseLinesTable,
          InventoryCloseLineRow
        >,
      ),
      InventoryCloseLineRow,
      PrefetchHooks Function()
    >;
typedef $$ProductExchangesTableCreateCompanionBuilder =
    ProductExchangesCompanion Function({
      required String id,
      required String storeId,
      required String shiftId,
      required String originalSaleId,
      required String returnProductId,
      required int returnQuantity,
      required int originalUnitPriceClp,
      required String newProductId,
      required int newQuantity,
      required int newUnitPriceClp,
      required int creditClp,
      required int chargeClp,
      required int differenceClp,
      required String newSaleId,
      required String createdAt,
      required String actorUserId,
      Value<String?> differencePaymentMethod,
      Value<int?> differencePaymentAmountClp,
      Value<String?> creditNoteId,
      Value<int> rowid,
    });
typedef $$ProductExchangesTableUpdateCompanionBuilder =
    ProductExchangesCompanion Function({
      Value<String> id,
      Value<String> storeId,
      Value<String> shiftId,
      Value<String> originalSaleId,
      Value<String> returnProductId,
      Value<int> returnQuantity,
      Value<int> originalUnitPriceClp,
      Value<String> newProductId,
      Value<int> newQuantity,
      Value<int> newUnitPriceClp,
      Value<int> creditClp,
      Value<int> chargeClp,
      Value<int> differenceClp,
      Value<String> newSaleId,
      Value<String> createdAt,
      Value<String> actorUserId,
      Value<String?> differencePaymentMethod,
      Value<int?> differencePaymentAmountClp,
      Value<String?> creditNoteId,
      Value<int> rowid,
    });

class $$ProductExchangesTableFilterComposer
    extends Composer<_$AppDatabase, $ProductExchangesTable> {
  $$ProductExchangesTableFilterComposer({
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

  ColumnFilters<String> get originalSaleId => $composableBuilder(
    column: $table.originalSaleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get returnProductId => $composableBuilder(
    column: $table.returnProductId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get returnQuantity => $composableBuilder(
    column: $table.returnQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get originalUnitPriceClp => $composableBuilder(
    column: $table.originalUnitPriceClp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get newProductId => $composableBuilder(
    column: $table.newProductId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get newQuantity => $composableBuilder(
    column: $table.newQuantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get newUnitPriceClp => $composableBuilder(
    column: $table.newUnitPriceClp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get creditClp => $composableBuilder(
    column: $table.creditClp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chargeClp => $composableBuilder(
    column: $table.chargeClp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get differenceClp => $composableBuilder(
    column: $table.differenceClp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get newSaleId => $composableBuilder(
    column: $table.newSaleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actorUserId => $composableBuilder(
    column: $table.actorUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get differencePaymentMethod => $composableBuilder(
    column: $table.differencePaymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get differencePaymentAmountClp => $composableBuilder(
    column: $table.differencePaymentAmountClp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get creditNoteId => $composableBuilder(
    column: $table.creditNoteId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductExchangesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductExchangesTable> {
  $$ProductExchangesTableOrderingComposer({
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

  ColumnOrderings<String> get originalSaleId => $composableBuilder(
    column: $table.originalSaleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get returnProductId => $composableBuilder(
    column: $table.returnProductId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get returnQuantity => $composableBuilder(
    column: $table.returnQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get originalUnitPriceClp => $composableBuilder(
    column: $table.originalUnitPriceClp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get newProductId => $composableBuilder(
    column: $table.newProductId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get newQuantity => $composableBuilder(
    column: $table.newQuantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get newUnitPriceClp => $composableBuilder(
    column: $table.newUnitPriceClp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get creditClp => $composableBuilder(
    column: $table.creditClp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chargeClp => $composableBuilder(
    column: $table.chargeClp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get differenceClp => $composableBuilder(
    column: $table.differenceClp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get newSaleId => $composableBuilder(
    column: $table.newSaleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actorUserId => $composableBuilder(
    column: $table.actorUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get differencePaymentMethod => $composableBuilder(
    column: $table.differencePaymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get differencePaymentAmountClp => $composableBuilder(
    column: $table.differencePaymentAmountClp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get creditNoteId => $composableBuilder(
    column: $table.creditNoteId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductExchangesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductExchangesTable> {
  $$ProductExchangesTableAnnotationComposer({
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

  GeneratedColumn<String> get originalSaleId => $composableBuilder(
    column: $table.originalSaleId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get returnProductId => $composableBuilder(
    column: $table.returnProductId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get returnQuantity => $composableBuilder(
    column: $table.returnQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get originalUnitPriceClp => $composableBuilder(
    column: $table.originalUnitPriceClp,
    builder: (column) => column,
  );

  GeneratedColumn<String> get newProductId => $composableBuilder(
    column: $table.newProductId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get newQuantity => $composableBuilder(
    column: $table.newQuantity,
    builder: (column) => column,
  );

  GeneratedColumn<int> get newUnitPriceClp => $composableBuilder(
    column: $table.newUnitPriceClp,
    builder: (column) => column,
  );

  GeneratedColumn<int> get creditClp =>
      $composableBuilder(column: $table.creditClp, builder: (column) => column);

  GeneratedColumn<int> get chargeClp =>
      $composableBuilder(column: $table.chargeClp, builder: (column) => column);

  GeneratedColumn<int> get differenceClp => $composableBuilder(
    column: $table.differenceClp,
    builder: (column) => column,
  );

  GeneratedColumn<String> get newSaleId =>
      $composableBuilder(column: $table.newSaleId, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get actorUserId => $composableBuilder(
    column: $table.actorUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get differencePaymentMethod => $composableBuilder(
    column: $table.differencePaymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<int> get differencePaymentAmountClp => $composableBuilder(
    column: $table.differencePaymentAmountClp,
    builder: (column) => column,
  );

  GeneratedColumn<String> get creditNoteId => $composableBuilder(
    column: $table.creditNoteId,
    builder: (column) => column,
  );
}

class $$ProductExchangesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductExchangesTable,
          ProductExchangeRow,
          $$ProductExchangesTableFilterComposer,
          $$ProductExchangesTableOrderingComposer,
          $$ProductExchangesTableAnnotationComposer,
          $$ProductExchangesTableCreateCompanionBuilder,
          $$ProductExchangesTableUpdateCompanionBuilder,
          (
            ProductExchangeRow,
            BaseReferences<
              _$AppDatabase,
              $ProductExchangesTable,
              ProductExchangeRow
            >,
          ),
          ProductExchangeRow,
          PrefetchHooks Function()
        > {
  $$ProductExchangesTableTableManager(
    _$AppDatabase db,
    $ProductExchangesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductExchangesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductExchangesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductExchangesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<String> shiftId = const Value.absent(),
                Value<String> originalSaleId = const Value.absent(),
                Value<String> returnProductId = const Value.absent(),
                Value<int> returnQuantity = const Value.absent(),
                Value<int> originalUnitPriceClp = const Value.absent(),
                Value<String> newProductId = const Value.absent(),
                Value<int> newQuantity = const Value.absent(),
                Value<int> newUnitPriceClp = const Value.absent(),
                Value<int> creditClp = const Value.absent(),
                Value<int> chargeClp = const Value.absent(),
                Value<int> differenceClp = const Value.absent(),
                Value<String> newSaleId = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> actorUserId = const Value.absent(),
                Value<String?> differencePaymentMethod = const Value.absent(),
                Value<int?> differencePaymentAmountClp = const Value.absent(),
                Value<String?> creditNoteId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductExchangesCompanion(
                id: id,
                storeId: storeId,
                shiftId: shiftId,
                originalSaleId: originalSaleId,
                returnProductId: returnProductId,
                returnQuantity: returnQuantity,
                originalUnitPriceClp: originalUnitPriceClp,
                newProductId: newProductId,
                newQuantity: newQuantity,
                newUnitPriceClp: newUnitPriceClp,
                creditClp: creditClp,
                chargeClp: chargeClp,
                differenceClp: differenceClp,
                newSaleId: newSaleId,
                createdAt: createdAt,
                actorUserId: actorUserId,
                differencePaymentMethod: differencePaymentMethod,
                differencePaymentAmountClp: differencePaymentAmountClp,
                creditNoteId: creditNoteId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required String shiftId,
                required String originalSaleId,
                required String returnProductId,
                required int returnQuantity,
                required int originalUnitPriceClp,
                required String newProductId,
                required int newQuantity,
                required int newUnitPriceClp,
                required int creditClp,
                required int chargeClp,
                required int differenceClp,
                required String newSaleId,
                required String createdAt,
                required String actorUserId,
                Value<String?> differencePaymentMethod = const Value.absent(),
                Value<int?> differencePaymentAmountClp = const Value.absent(),
                Value<String?> creditNoteId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductExchangesCompanion.insert(
                id: id,
                storeId: storeId,
                shiftId: shiftId,
                originalSaleId: originalSaleId,
                returnProductId: returnProductId,
                returnQuantity: returnQuantity,
                originalUnitPriceClp: originalUnitPriceClp,
                newProductId: newProductId,
                newQuantity: newQuantity,
                newUnitPriceClp: newUnitPriceClp,
                creditClp: creditClp,
                chargeClp: chargeClp,
                differenceClp: differenceClp,
                newSaleId: newSaleId,
                createdAt: createdAt,
                actorUserId: actorUserId,
                differencePaymentMethod: differencePaymentMethod,
                differencePaymentAmountClp: differencePaymentAmountClp,
                creditNoteId: creditNoteId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductExchangesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductExchangesTable,
      ProductExchangeRow,
      $$ProductExchangesTableFilterComposer,
      $$ProductExchangesTableOrderingComposer,
      $$ProductExchangesTableAnnotationComposer,
      $$ProductExchangesTableCreateCompanionBuilder,
      $$ProductExchangesTableUpdateCompanionBuilder,
      (
        ProductExchangeRow,
        BaseReferences<
          _$AppDatabase,
          $ProductExchangesTable,
          ProductExchangeRow
        >,
      ),
      ProductExchangeRow,
      PrefetchHooks Function()
    >;
typedef $$CreditNotesTableCreateCompanionBuilder =
    CreditNotesCompanion Function({
      required String id,
      required String storeId,
      required String saleId,
      required int totalClp,
      required String dteStatus,
      Value<int?> folio,
      Value<String?> pdfUrl,
      required String createdAt,
      required String actorUserId,
      required int referencedSaleFolio,
      required int referencedDocumentType,
      Value<int> rowid,
    });
typedef $$CreditNotesTableUpdateCompanionBuilder =
    CreditNotesCompanion Function({
      Value<String> id,
      Value<String> storeId,
      Value<String> saleId,
      Value<int> totalClp,
      Value<String> dteStatus,
      Value<int?> folio,
      Value<String?> pdfUrl,
      Value<String> createdAt,
      Value<String> actorUserId,
      Value<int> referencedSaleFolio,
      Value<int> referencedDocumentType,
      Value<int> rowid,
    });

class $$CreditNotesTableFilterComposer
    extends Composer<_$AppDatabase, $CreditNotesTable> {
  $$CreditNotesTableFilterComposer({
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

  ColumnFilters<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalClp => $composableBuilder(
    column: $table.totalClp,
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

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get actorUserId => $composableBuilder(
    column: $table.actorUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get referencedSaleFolio => $composableBuilder(
    column: $table.referencedSaleFolio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get referencedDocumentType => $composableBuilder(
    column: $table.referencedDocumentType,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CreditNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $CreditNotesTable> {
  $$CreditNotesTableOrderingComposer({
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

  ColumnOrderings<String> get saleId => $composableBuilder(
    column: $table.saleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalClp => $composableBuilder(
    column: $table.totalClp,
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

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get actorUserId => $composableBuilder(
    column: $table.actorUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get referencedSaleFolio => $composableBuilder(
    column: $table.referencedSaleFolio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get referencedDocumentType => $composableBuilder(
    column: $table.referencedDocumentType,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CreditNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreditNotesTable> {
  $$CreditNotesTableAnnotationComposer({
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

  GeneratedColumn<String> get saleId =>
      $composableBuilder(column: $table.saleId, builder: (column) => column);

  GeneratedColumn<int> get totalClp =>
      $composableBuilder(column: $table.totalClp, builder: (column) => column);

  GeneratedColumn<String> get dteStatus =>
      $composableBuilder(column: $table.dteStatus, builder: (column) => column);

  GeneratedColumn<int> get folio =>
      $composableBuilder(column: $table.folio, builder: (column) => column);

  GeneratedColumn<String> get pdfUrl =>
      $composableBuilder(column: $table.pdfUrl, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get actorUserId => $composableBuilder(
    column: $table.actorUserId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get referencedSaleFolio => $composableBuilder(
    column: $table.referencedSaleFolio,
    builder: (column) => column,
  );

  GeneratedColumn<int> get referencedDocumentType => $composableBuilder(
    column: $table.referencedDocumentType,
    builder: (column) => column,
  );
}

class $$CreditNotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreditNotesTable,
          CreditNoteRow,
          $$CreditNotesTableFilterComposer,
          $$CreditNotesTableOrderingComposer,
          $$CreditNotesTableAnnotationComposer,
          $$CreditNotesTableCreateCompanionBuilder,
          $$CreditNotesTableUpdateCompanionBuilder,
          (
            CreditNoteRow,
            BaseReferences<_$AppDatabase, $CreditNotesTable, CreditNoteRow>,
          ),
          CreditNoteRow,
          PrefetchHooks Function()
        > {
  $$CreditNotesTableTableManager(_$AppDatabase db, $CreditNotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreditNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreditNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreditNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<String> saleId = const Value.absent(),
                Value<int> totalClp = const Value.absent(),
                Value<String> dteStatus = const Value.absent(),
                Value<int?> folio = const Value.absent(),
                Value<String?> pdfUrl = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> actorUserId = const Value.absent(),
                Value<int> referencedSaleFolio = const Value.absent(),
                Value<int> referencedDocumentType = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CreditNotesCompanion(
                id: id,
                storeId: storeId,
                saleId: saleId,
                totalClp: totalClp,
                dteStatus: dteStatus,
                folio: folio,
                pdfUrl: pdfUrl,
                createdAt: createdAt,
                actorUserId: actorUserId,
                referencedSaleFolio: referencedSaleFolio,
                referencedDocumentType: referencedDocumentType,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String storeId,
                required String saleId,
                required int totalClp,
                required String dteStatus,
                Value<int?> folio = const Value.absent(),
                Value<String?> pdfUrl = const Value.absent(),
                required String createdAt,
                required String actorUserId,
                required int referencedSaleFolio,
                required int referencedDocumentType,
                Value<int> rowid = const Value.absent(),
              }) => CreditNotesCompanion.insert(
                id: id,
                storeId: storeId,
                saleId: saleId,
                totalClp: totalClp,
                dteStatus: dteStatus,
                folio: folio,
                pdfUrl: pdfUrl,
                createdAt: createdAt,
                actorUserId: actorUserId,
                referencedSaleFolio: referencedSaleFolio,
                referencedDocumentType: referencedDocumentType,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CreditNotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreditNotesTable,
      CreditNoteRow,
      $$CreditNotesTableFilterComposer,
      $$CreditNotesTableOrderingComposer,
      $$CreditNotesTableAnnotationComposer,
      $$CreditNotesTableCreateCompanionBuilder,
      $$CreditNotesTableUpdateCompanionBuilder,
      (
        CreditNoteRow,
        BaseReferences<_$AppDatabase, $CreditNotesTable, CreditNoteRow>,
      ),
      CreditNoteRow,
      PrefetchHooks Function()
    >;
typedef $$CreditNoteLinesTableCreateCompanionBuilder =
    CreditNoteLinesCompanion Function({
      required String id,
      required String creditNoteId,
      required String productId,
      required String productName,
      required int quantity,
      required int unitPriceClp,
      Value<int> rowid,
    });
typedef $$CreditNoteLinesTableUpdateCompanionBuilder =
    CreditNoteLinesCompanion Function({
      Value<String> id,
      Value<String> creditNoteId,
      Value<String> productId,
      Value<String> productName,
      Value<int> quantity,
      Value<int> unitPriceClp,
      Value<int> rowid,
    });

class $$CreditNoteLinesTableFilterComposer
    extends Composer<_$AppDatabase, $CreditNoteLinesTable> {
  $$CreditNoteLinesTableFilterComposer({
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

  ColumnFilters<String> get creditNoteId => $composableBuilder(
    column: $table.creditNoteId,
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

class $$CreditNoteLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $CreditNoteLinesTable> {
  $$CreditNoteLinesTableOrderingComposer({
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

  ColumnOrderings<String> get creditNoteId => $composableBuilder(
    column: $table.creditNoteId,
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

class $$CreditNoteLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CreditNoteLinesTable> {
  $$CreditNoteLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get creditNoteId => $composableBuilder(
    column: $table.creditNoteId,
    builder: (column) => column,
  );

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

class $$CreditNoteLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CreditNoteLinesTable,
          CreditNoteLineRow,
          $$CreditNoteLinesTableFilterComposer,
          $$CreditNoteLinesTableOrderingComposer,
          $$CreditNoteLinesTableAnnotationComposer,
          $$CreditNoteLinesTableCreateCompanionBuilder,
          $$CreditNoteLinesTableUpdateCompanionBuilder,
          (
            CreditNoteLineRow,
            BaseReferences<
              _$AppDatabase,
              $CreditNoteLinesTable,
              CreditNoteLineRow
            >,
          ),
          CreditNoteLineRow,
          PrefetchHooks Function()
        > {
  $$CreditNoteLinesTableTableManager(
    _$AppDatabase db,
    $CreditNoteLinesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CreditNoteLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CreditNoteLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CreditNoteLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> creditNoteId = const Value.absent(),
                Value<String> productId = const Value.absent(),
                Value<String> productName = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<int> unitPriceClp = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CreditNoteLinesCompanion(
                id: id,
                creditNoteId: creditNoteId,
                productId: productId,
                productName: productName,
                quantity: quantity,
                unitPriceClp: unitPriceClp,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String creditNoteId,
                required String productId,
                required String productName,
                required int quantity,
                required int unitPriceClp,
                Value<int> rowid = const Value.absent(),
              }) => CreditNoteLinesCompanion.insert(
                id: id,
                creditNoteId: creditNoteId,
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

typedef $$CreditNoteLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CreditNoteLinesTable,
      CreditNoteLineRow,
      $$CreditNoteLinesTableFilterComposer,
      $$CreditNoteLinesTableOrderingComposer,
      $$CreditNoteLinesTableAnnotationComposer,
      $$CreditNoteLinesTableCreateCompanionBuilder,
      $$CreditNoteLinesTableUpdateCompanionBuilder,
      (
        CreditNoteLineRow,
        BaseReferences<_$AppDatabase, $CreditNoteLinesTable, CreditNoteLineRow>,
      ),
      CreditNoteLineRow,
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
typedef $$InvoiceCustomersTableCreateCompanionBuilder =
    InvoiceCustomersCompanion Function({
      required String storeId,
      required String rut,
      required String businessName,
      required String giro,
      required String email,
      required String address,
      required String city,
      required String commune,
      required String phone,
      Value<int> rowid,
    });
typedef $$InvoiceCustomersTableUpdateCompanionBuilder =
    InvoiceCustomersCompanion Function({
      Value<String> storeId,
      Value<String> rut,
      Value<String> businessName,
      Value<String> giro,
      Value<String> email,
      Value<String> address,
      Value<String> city,
      Value<String> commune,
      Value<String> phone,
      Value<int> rowid,
    });

class $$InvoiceCustomersTableFilterComposer
    extends Composer<_$AppDatabase, $InvoiceCustomersTable> {
  $$InvoiceCustomersTableFilterComposer({
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

  ColumnFilters<String> get rut => $composableBuilder(
    column: $table.rut,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get businessName => $composableBuilder(
    column: $table.businessName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get giro => $composableBuilder(
    column: $table.giro,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get commune => $composableBuilder(
    column: $table.commune,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InvoiceCustomersTableOrderingComposer
    extends Composer<_$AppDatabase, $InvoiceCustomersTable> {
  $$InvoiceCustomersTableOrderingComposer({
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

  ColumnOrderings<String> get rut => $composableBuilder(
    column: $table.rut,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get businessName => $composableBuilder(
    column: $table.businessName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get giro => $composableBuilder(
    column: $table.giro,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get commune => $composableBuilder(
    column: $table.commune,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InvoiceCustomersTableAnnotationComposer
    extends Composer<_$AppDatabase, $InvoiceCustomersTable> {
  $$InvoiceCustomersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get rut =>
      $composableBuilder(column: $table.rut, builder: (column) => column);

  GeneratedColumn<String> get businessName => $composableBuilder(
    column: $table.businessName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get giro =>
      $composableBuilder(column: $table.giro, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<String> get commune =>
      $composableBuilder(column: $table.commune, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);
}

class $$InvoiceCustomersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InvoiceCustomersTable,
          InvoiceCustomerRow,
          $$InvoiceCustomersTableFilterComposer,
          $$InvoiceCustomersTableOrderingComposer,
          $$InvoiceCustomersTableAnnotationComposer,
          $$InvoiceCustomersTableCreateCompanionBuilder,
          $$InvoiceCustomersTableUpdateCompanionBuilder,
          (
            InvoiceCustomerRow,
            BaseReferences<
              _$AppDatabase,
              $InvoiceCustomersTable,
              InvoiceCustomerRow
            >,
          ),
          InvoiceCustomerRow,
          PrefetchHooks Function()
        > {
  $$InvoiceCustomersTableTableManager(
    _$AppDatabase db,
    $InvoiceCustomersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InvoiceCustomersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InvoiceCustomersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InvoiceCustomersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> storeId = const Value.absent(),
                Value<String> rut = const Value.absent(),
                Value<String> businessName = const Value.absent(),
                Value<String> giro = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<String> commune = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InvoiceCustomersCompanion(
                storeId: storeId,
                rut: rut,
                businessName: businessName,
                giro: giro,
                email: email,
                address: address,
                city: city,
                commune: commune,
                phone: phone,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String storeId,
                required String rut,
                required String businessName,
                required String giro,
                required String email,
                required String address,
                required String city,
                required String commune,
                required String phone,
                Value<int> rowid = const Value.absent(),
              }) => InvoiceCustomersCompanion.insert(
                storeId: storeId,
                rut: rut,
                businessName: businessName,
                giro: giro,
                email: email,
                address: address,
                city: city,
                commune: commune,
                phone: phone,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InvoiceCustomersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InvoiceCustomersTable,
      InvoiceCustomerRow,
      $$InvoiceCustomersTableFilterComposer,
      $$InvoiceCustomersTableOrderingComposer,
      $$InvoiceCustomersTableAnnotationComposer,
      $$InvoiceCustomersTableCreateCompanionBuilder,
      $$InvoiceCustomersTableUpdateCompanionBuilder,
      (
        InvoiceCustomerRow,
        BaseReferences<
          _$AppDatabase,
          $InvoiceCustomersTable,
          InvoiceCustomerRow
        >,
      ),
      InvoiceCustomerRow,
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
  $$InventoryClosesTableTableManager get inventoryCloses =>
      $$InventoryClosesTableTableManager(_db, _db.inventoryCloses);
  $$InventoryCloseLinesTableTableManager get inventoryCloseLines =>
      $$InventoryCloseLinesTableTableManager(_db, _db.inventoryCloseLines);
  $$ProductExchangesTableTableManager get productExchanges =>
      $$ProductExchangesTableTableManager(_db, _db.productExchanges);
  $$CreditNotesTableTableManager get creditNotes =>
      $$CreditNotesTableTableManager(_db, _db.creditNotes);
  $$CreditNoteLinesTableTableManager get creditNoteLines =>
      $$CreditNoteLinesTableTableManager(_db, _db.creditNoteLines);
  $$DteFolioCountersTableTableManager get dteFolioCounters =>
      $$DteFolioCountersTableTableManager(_db, _db.dteFolioCounters);
  $$ClockStateTableTableManager get clockState =>
      $$ClockStateTableTableManager(_db, _db.clockState);
  $$InvoiceCustomersTableTableManager get invoiceCustomers =>
      $$InvoiceCustomersTableTableManager(_db, _db.invoiceCustomers);
}
