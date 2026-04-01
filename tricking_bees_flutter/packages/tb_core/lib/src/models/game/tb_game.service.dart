// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// ServiceGenerator
// **************************************************************************

// ignore_for_file: directives_ordering, prefer_relative_imports, empty_statements, lines_longer_than_80_chars
import 'package:yust/yust.dart';
import 'package:tb_core/src/models/game/tb_game.dart';

/// A service to get elements of [TBGame].
class TBGameService {
  /// Returns a stream of a [TBGame].
  ///
  ///
  /// Whenever another user makes a change, a new version of the document is returned.
  ///
  static Stream<TBGame?> getStream(String id) =>
      Yust.databaseService.getStream(TBGame.setup(), id);

  /// Returns a stream of the first [TBGame].
  ///
  ///
  /// Whenever another user makes a change, a new version of the document is returned.
  /// The result is null if no document was found.
  static Stream<TBGame?> getFirstStream({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
  }) => Yust.databaseService.getFirstStream(
    TBGame.setup(),
    filters: filters,
    orderBy: orderBy,
  );

  /// Returns a stream of [TBGame]s.
  ///
  ///
  /// Whenever another user makes a change, a new version of the document is returned.
  ///
  /// [filters] each entry represents a condition that has to be met.
  /// All of those conditions must be true for each returned entry.
  ///
  /// [orderBy] orders the returned records.
  /// Multiple of those entries can be repeated.
  ///
  /// [limit] can be passed to only get at most n documents.
  static Stream<List<TBGame>> getListStream({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
    int? limit,
  }) => Yust.databaseService.getListStream(
    TBGame.setup(),
    filters: filters,
    orderBy: orderBy,
    limit: limit,
  );

  /// Returns a [TBGame] directly from the server, if available, otherwise from the cache.
  ///
  ///
  /// Be careful with offline functionality.
  ///
  static Future<TBGame?> getFromDB(String id) =>
      Yust.databaseService.getFromDB(TBGame.setup(), id);

  /// Returns the first [TBGame] directly from the server, if available, otherwise from the cache.
  ///
  ///
  /// Be careful with offline functionality.
  /// The result is null if no document was found.
  static Future<TBGame?> getFirstFromDB({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
  }) => Yust.databaseService.getFirstFromDB(
    TBGame.setup(),
    filters: filters,
    orderBy: orderBy,
  );

  /// Returns [TBGame]s directly from the server, if available, otherwise from the cache.
  ///
  ///
  /// Be careful with offline functionality.
  ///
  /// [filters] each entry represents a condition that has to be met.
  /// All of those conditions must be true for each returned entry.
  ///
  /// [orderBy] orders the returned records.
  /// Multiple of those entries can be repeated.
  ///
  /// [limit] can be passed to only get at most n documents.
  static Future<List<TBGame>> getListFromDB({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
    int? limit,
  }) => Yust.databaseService.getListFromDB(
    TBGame.setup(),
    filters: filters,
    orderBy: orderBy,
    limit: limit,
  );

  /// Returns a [TBGame] from the cache, if available, otherwise from the server.
  /// The cached documents may not be up to date!
  ///
  /// Be careful with offline functionality.
  ///
  static Future<TBGame?> getFromCache(String id) =>
      Yust.databaseService.getFromCache(TBGame.setup(), id);

  /// Returns the first [TBGame] from the cache, if available, otherwise from the server.
  /// The cached documents may not be up to date!
  ///
  /// Be careful with offline functionality.
  /// The result is null if no document was found.
  static Future<TBGame?> getFirstFromCache({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
  }) => Yust.databaseService.getFirstFromCache(
    TBGame.setup(),
    filters: filters,
    orderBy: orderBy,
  );

  /// Returns [TBGame]s from the cache, if available, otherwise from the server.
  /// The cached documents may not be up to date!
  ///
  /// Be careful with offline functionality.
  ///
  /// [filters] each entry represents a condition that has to be met.
  /// All of those conditions must be true for each returned entry.
  ///
  /// [orderBy] orders the returned records.
  /// Multiple of those entries can be repeated.
  ///
  /// [limit] can be passed to only get at most n documents.
  static Future<List<TBGame>> getListFromCache({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
    int? limit,
  }) => Yust.databaseService.getListFromCache(
    TBGame.setup(),
    filters: filters,
    orderBy: orderBy,
    limit: limit,
  );

  /// Returns a [TBGame] from the server, if available, otherwise from the cache.
  /// The cached documents may not be up to date!
  ///
  /// Be careful with offline functionality.
  ///
  static Future<TBGame?> get(String id) =>
      Yust.databaseService.get(TBGame.setup(), id);

  /// Returns the first [TBGame] from the server, if available, otherwise from the cache.
  /// The cached documents may not be up to date!
  ///
  /// Be careful with offline functionality.
  /// The result is null if no document was found.
  static Future<TBGame?> getFirst({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
  }) => Yust.databaseService.getFirst(
    TBGame.setup(),
    filters: filters,
    orderBy: orderBy,
  );

  /// Returns [TBGame]s from the server, if available, otherwise from the cache.
  /// The cached documents may not be up to date!
  ///
  /// Be careful with offline functionality.
  ///
  /// [filters] each entry represents a condition that has to be met.
  /// All of those conditions must be true for each returned entry.
  ///
  /// [orderBy] orders the returned records.
  /// Multiple of those entries can be repeated.
  ///
  /// [limit] can be passed to only get at most n documents.
  static Future<List<TBGame>> getList({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
    int? limit,
  }) => Yust.databaseService.getList(
    TBGame.setup(),
    filters: filters,
    orderBy: orderBy,
    limit: limit,
  );

  /// Returns [TBGame]s as a lazy, chunked Stream from the database.
  ///
  /// This is much more memory efficient in comparison to other methods,
  /// because of three reasons:
  /// 1. It gets the data in multiple requests ([pageSize] each); the raw json
  ///    strings and raw maps are only in memory while one chunk is processed.
  /// 2. It loads the records *lazily*, meaning only one chunk is in memory while
  ///    the records worked with (e.g. via a `await for(...)`)
  /// 3. It doesn't use the google_apis package for the request, because that
  ///    has a huge memory leak
  ///
  /// NOTE: Because this is a Stream you may only iterate over it once,
  /// listening to it multiple times will result in a runtime-exception!
  ///
  /// [filters] each entry represents a condition that has to be met.
  /// All of those conditions must be true for each returned entry.
  ///
  /// [orderBy] orders the returned records.
  /// Multiple of those entries can be repeated.
  ///
  static Stream<TBGame> getListChunked({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
    int pageSize = 5000,
  }) => Yust.databaseService.getListChunked(
    TBGame.setup(),
    filters: filters,
    orderBy: orderBy,
    pageSize: pageSize,
  );

  /// Returns the count of [TBGame]s in the database.
  ///
  /// Please note, that this is still priced per item, therefore don't overuse it
  /// on large collections.
  ///
  /// [filters] each entry represents a condition that has to be met.
  /// All of those conditions must be true for each returned entry.
  ///
  ///
  static Future<int> count({List<YustFilter>? filters}) =>
      Yust.databaseService.count(TBGame.setup(), filters: filters);

  /// Initializes a [TBGame] with an id and the time it was created.
  ///
  /// Optionally an existing [TBGame] can be given, which will still be
  /// assigned a new id becoming a new [TBGame] if it had an id previously.
  static TBGame init([TBGame? doc]) =>
      Yust.databaseService.initDoc(TBGame.setup(), doc);

  /// Delete all [TBGame]s in the filter.
  static Future<void> deleteAll({List<YustFilter>? filters}) =>
      Yust.databaseService.deleteDocs(TBGame.setup(), filters: filters);

  /// Delete a [TBGame].
  static Future<void> deleteById(String id) =>
      Yust.databaseService.deleteDocById(TBGame.setup(), id);
}

/// An extension to save and delete elements of [TBGame].
extension TBGameSave on TBGame {
  /// Saves the document.
  Future<void> save({
    bool merge = true,
    bool? trackModification,
    bool skipOnSave = false,
    bool? removeNullValues,
    bool doNotCreate = false,
  }) async {
    await Yust.databaseService.saveDoc(
      TBGame.setup(),
      this,
      trackModification: trackModification ?? false,
      skipOnSave: skipOnSave,
      doNotCreate: doNotCreate,
      merge: merge,
      removeNullValues: removeNullValues,
    );
  }

  /// Transforms (e.g. increment, decrement) a documents fields.
  Future<void> updateByTransform(
    List<YustFieldTransform> fieldTransforms, {
    bool? removeNullValues,
    bool skipOnSave = false,
  }) => Yust.databaseService.updateDocByTransform(
    TBGame.setup(),
    id,
    fieldTransforms,
    removeNullValues: removeNullValues,
    skipOnSave: skipOnSave,
  );

  /// Deletes the document.
  Future<void> delete() => Yust.databaseService.deleteDoc(TBGame.setup(), this);
}
