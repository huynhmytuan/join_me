import 'package:join_me/data/models/models.dart';

final postsData = [
  Post(
    id: 'id1',
    type: PostType.invitation,
    authorId: 'id2',
    createdAt: DateTime.now(),
    content: 'a short part of a text, consisting of at least one sentence and',
    projectInvitationId: '123',
    likes: const ['123', '123', '123'],
    imageUrls: const ['https://picsum.photos/seed/picsum/536/354'],
  ),
  Post(
    id: 'id2',
    type: PostType.invitation,
    authorId: 'id1',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    content: 'a short part of a text, consisting ',
    projectInvitationId: '123',
    likes: const ['123', '123', '123', '123', '123'],
    imageUrls: const [
      'https://picsum.photos/id/237/536/354',
      'https://picsum.photos/seed/picsum/536/354'
    ],
  ),
  Post(
    id: 'id3',
    type: PostType.normal,
    authorId: 'id3',
    createdAt: DateTime.now(),
    content: 'a short  at least one sentence and',
    projectInvitationId: '123',
    likes: const ['123', '123', '123'],
    imageUrls: const [
      'https://picsum.photos/id/237/536/354',
      'https://picsum.photos/seed/picsum/536/354'
    ],
  ),
];

final commentsData = [
  Comment(
    createdAt: DateTime.now(),
    content: 'Xin cha',
    authorId: 'id3',
    postId: 'id1',
    likes: const [],
  ),
  Comment(
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    content: 'Xin Hello Min Max and a lot of thing that we don know about',
    authorId: 'id1',
    postId: 'id2',
    likes: const [],
  ),
  Comment(
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    content: 'Xin Hello Min Max and a lot of thing that we don know about',
    authorId: 'id2',
    postId: 'id1',
    likes: const [],
  ),
  Comment(
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    content: 'Xin Hello Min Max and a lot of thing that we don know about',
    authorId: 'id1',
    postId: 'id3',
    likes: const [],
  ),
];

const usersData = [
  User(
    id: 'id1',
    displayName: 'Huy Tin',
    email: 'email@email.com',
    personalBio: 'personalBio',
    photoUrl: 'https://picsum.photos/id/237/536/354',
  ),
  User(
    id: 'id2',
    displayName: 'Aria Lois',
    email: 'aria@email.com',
    personalBio: 'personalBio',
    photoUrl: 'https://picsum.photos/id/237/536/354',
  ),
  User(
    id: 'id3',
    displayName: 'Huy Tin',
    email: 'email@email.com',
    personalBio: 'personalBio',
    photoUrl: 'https://picsum.photos/id/237/536/354',
  ),
];
