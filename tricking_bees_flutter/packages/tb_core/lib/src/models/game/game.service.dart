// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ServiceGenerator
// **************************************************************************

// ignore_for_file: directives_ordering, prefer_relative_imports, empty_statements, lines_longer_than_80_chars
import 'package:yust/yust.dart';
import 'package:tb_core/src/models/game/game.dart';

/// A service to get elements of [Game].
class GameService {
  /// Returns a stream of a [Game].
  ///
  ///
  /// Whenever another user makes a change, a new version of the document is returned.
  ///
  static Stream<Game?> getStream(String id) =>
      Yust.databaseService.getStream<Game>(
        Game.setup(),
        id,
      );

  /// Returns a stream of the first [Game].
  ///
  ///
  /// Whenever another user makes a change, a new version of the document is returned.
  /// The result is null if no document was found.
  static Stream<Game?> getFirstStream({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
  }) =>
      Yust.databaseService.getFirstStream<Game>(
        Game.setup(),
        filters: filters,
        orderBy: orderBy,
      );

  /// Returns a stream of [Game]s.
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
  static Stream<List<Game>> getListStream({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
    int? limit,
  }) =>
      Yust.databaseService.getListStream<Game>(
        Game.setup(),
        filters: filters,
        orderBy: orderBy,
        limit: limit,
      );

  /// Returns a [Game] directly from the server, if available, otherwise from the cache.
  ///
  ///
  /// Be careful with offline functionality.
  ///
  static Future<Game?> getFromDB(String id) async =>
      Yust.databaseService.getFromDB<Game>(
        Game.setup(),
        id,
      );

  /// Returns the first [Game] directly from the server, if available, otherwise from the cache.
  ///
  ///
  /// Be careful with offline functionality.
  /// The result is null if no document was found.
  static Future<Game?> getFirstFromDB({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
  }) async =>
      Yust.databaseService.getFirstFromDB<Game>(
        Game.setup(),
        filters: filters,
        orderBy: orderBy,
      );

  /// Returns [Game]s directly from the server, if available, otherwise from the cache.
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
  static Future<List<Game>> getListFromDB({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
    int? limit,
  }) async =>
      Yust.databaseService.getListFromDB<Game>(
        Game.setup(),
        filters: filters,
        orderBy: orderBy,
        limit: limit,
      );

  /// Returns a [Game] from the cache, if available, otherwise from the server.
  /// The cached documents may not be up to date!
  ///
  /// Be careful with offline functionality.
  ///
  static Future<Game?> getFromCache(String id) async =>
      Yust.databaseService.getFromCache<Game>(
        Game.setup(),
        id,
      );

  /// Returns the first [Game] from the cache, if available, otherwise from the server.
  /// The cached documents may not be up to date!
  ///
  /// Be careful with offline functionality.
  /// The result is null if no document was found.
  static Future<Game?> getFirstFromCache({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
  }) async =>
      Yust.databaseService.getFirstFromCache<Game>(
        Game.setup(),
        filters: filters,
        orderBy: orderBy,
      );

  /// Returns [Game]s from the cache, if available, otherwise from the server.
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
  static Future<List<Game>> getListFromCache({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
    int? limit,
  }) async =>
      Yust.databaseService.getListFromCache<Game>(
        Game.setup(),
        filters: filters,
        orderBy: orderBy,
        limit: limit,
      );

  /// Returns a [Game] from the server, if available, otherwise from the cache.
  /// The cached documents may not be up to date!
  ///
  /// Be careful with offline functionality.
  ///
  static Future<Game?> get(String id) async => Yust.databaseService.get<Game>(
        Game.setup(),
        id,
      );

  /// Returns the first [Game] from the server, if available, otherwise from the cache.
  /// The cached documents may not be up to date!
  ///
  /// Be careful with offline functionality.
  /// The result is null if no document was found.
  static Future<Game?> getFirst({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
  }) async =>
      Yust.databaseService.getFirst<Game>(
        Game.setup(),
        filters: filters,
        orderBy: orderBy,
      );

  /// Returns [Game]s from the server, if available, otherwise from the cache.
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
  static Future<List<Game>> getList({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
    int? limit,
  }) async =>
      Yust.databaseService.getList<Game>(
        Game.setup(),
        filters: filters,
        orderBy: orderBy,
        limit: limit,
      );

  /// Returns [Game]s as a lazy, chunked Stream from the database.
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
  static Stream<Game> getListChunked({
    List<YustFilter>? filters,
    List<YustOrderBy>? orderBy,
    int pageSize = 5000,
  }) =>
      Yust.databaseService.getListChunked<Game>(
        Game.setup(),
        filters: filters,
        orderBy: orderBy,
        pageSize: pageSize,
      );

  /// Returns the count of [Game]s in the database.
  ///
  /// Please note, that this is still priced per item, therefore don't overuse it
  /// on large collections.
  ///
  /// [filters] each entry represents a condition that has to be met.
  /// All of those conditions must be true for each returned entry.
  ///
  ///
  static Future<int?> count({List<YustFilter>? filters}) =>
      Yust.databaseService.count<Game>(
        Game.setup(),
        filters: filters,
      );

  /// Initializes a [Game] with an id and the time it was created.
  ///
  /// Optionally an existing [Game] can be given, which will still be
  /// assigned a new id becoming a new [Game] if it had an id previously.
  static Game init([Game? doc]) => Yust.databaseService.initDoc<Game>(
        Game.setup(),
        doc,
      );

  /// Delete all [Game]s in the filter.
  static Future<void> deleteAll({List<YustFilter>? filters}) =>
      Yust.databaseService.deleteDocs<Game>(
        Game.setup(),
        filters: filters,
      );

  /// Delete a [Game].
  static Future<void> deleteById(String id) =>
      Yust.databaseService.deleteDocById<Game>(
        Game.setup(),
        id,
      );
}

/// An extension to save and delete elements of [Game].
extension GameSave on Game {
  /// Saves the document.
  Future<void> save({
    bool merge = true,
    bool? trackModification,
    bool skipOnSave = false,
    bool? removeNullValues,
    bool doNotCreate = false,
  }) async {
    await Yust.databaseService.saveDoc<Game>(
      Game.setup(),
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
  }) async =>
      Yust.databaseService.updateDocByTransform<Game>(
        Game.setup(),
        id,
        fieldTransforms,
        removeNullValues: removeNullValues,
        skipOnSave: skipOnSave,
      );

  /// Deletes the document.
  Future<void> delete() async => Yust.databaseService.deleteDoc<Game>(
        Game.setup(),
        this,
      );
}
