import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note_model.dart';

class NotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'notes';

  Stream<List<Note>> getUserNotes(String userId) {
    return _firestore
        .collection(_collection)
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      final notes =
          snapshot.docs.map((doc) => Note.fromFirestore(doc)).toList();
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return notes;
    });
  }

  Future<void> createNote(Note note) async {
    try {
      await _firestore.collection(_collection).add(note.toFirestore());
    } catch (e) {
      throw 'Unable to create note. Please try again.';
    }
  }

  Future<void> updateNote(Note note) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(note.id)
          .update(note.toFirestore());
    } catch (e) {
      throw 'Unable to update note. Please try again.';
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await _firestore.collection(_collection).doc(noteId).delete();
    } catch (e) {
      throw 'Unable to delete note. Please try again.';
    }
  }

  Future<Note?> getNoteById(String noteId) async {
    try {
      final doc = await _firestore.collection(_collection).doc(noteId).get();
      if (doc.exists) {
        return Note.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw 'Unable to load note. Please try again.';
    }
  }
}
