import 'package:join_me/data/models/models.dart';
import 'package:join_me/utilities/constant.dart';

final postsData = [
  Post(
    id: 'id1',
    type: PostType.invitation,
    authorId: 'id2',
    createdAt: DateTime.now(),
    content: 'a short part of a text, consisting of at least one sentence and',
    projectInvitationId: '123',
    likes: const ['123', '123', '123'],
    medias: const [
      'https://images.unsplash.com/photo-1579725854926-dbeab39780bc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8YWxvbmV8ZW58MHx8MHx8&w=1000&q=80',
    ],
    commentCount: 0,
  ),
  Post(
    id: 'id2',
    type: PostType.invitation,
    authorId: 'id1',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    content: 'a short part of a text, consisting ',
    projectInvitationId: '123',
    likes: const ['123', '123', '123', '123', '123'],
    medias: const [
      'https://picsum.photos/id/237/536/354',
      'https://picsum.photos/seed/picsum/536/354'
    ],
    commentCount: 0,
  ),
  Post(
    id: 'id3',
    type: PostType.normal,
    authorId: 'id3',
    createdAt: DateTime.now(),
    content: 'a short  at least one sentence and',
    projectInvitationId: '123',
    likes: const ['123', '123', '123'],
    medias: const [
      'https://picsum.photos/id/237/536/354',
      'https://picsum.photos/id/237/536/354',
      'https://picsum.photos/id/237/536/354',
      'https://picsum.photos/id/237/536/354',
      'https://picsum.photos/id/237/536/354',
      'https://picsum.photos/id/237/536/354',
      'https://picsum.photos/id/237/536/354',
      'https://picsum.photos/id/237/536/354',
      'https://picsum.photos/seed/picsum/536/354'
    ],
    commentCount: 0,
  ),
  Post(
    id: 'id4',
    type: PostType.normal,
    authorId: 'id4',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    content: 'hello hello hello hello hello ',
    projectInvitationId: '',
    likes: const ['123', '123', '123', '123', '123'],
    medias: const [],
    commentCount: 0,
  ),
];

final commentsData = [
  Comment(
    id: '123',
    createdAt: DateTime.now(),
    content: 'Xin cha',
    authorId: 'id3',
    postId: 'id1',
    likes: const [],
  ),
  Comment(
    id: '124',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    content: 'Xin Hello Min Max and a lot of thing that we don know about',
    authorId: 'id1',
    postId: 'id2',
    likes: const [],
  ),
  Comment(
    id: '125',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    content: 'Xin Hello Min Max and a lot of thing that we don know about',
    authorId: 'id2',
    postId: 'id1',
    likes: const [],
  ),
  Comment(
    id: '126',
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    content: 'Xin Hello Min Max and a lot of thing that we don know about',
    authorId: 'id1',
    postId: 'id3',
    likes: const [],
  ),
];

const usersData = [
  AppUser(
    id: 'id1',
    name: 'Huy Tin',
    email: 'email@email.com',
    personalBio: 'personalBio',
    photoUrl: 'https://picsum.photos/id/237/536/354',
  ),
  AppUser(
    id: 'id2',
    name: 'Aria Lois',
    email: 'aria@email.com',
    personalBio: 'personalBio',
    photoUrl: 'https://picsum.photos/id/237/536/354',
  ),
  AppUser(
    id: 'id3',
    name: 'Huy Tin',
    email: 'email@email.com',
    personalBio: 'personalBio',
    photoUrl: 'https://picsum.photos/id/237/536/354',
  ),
  AppUser(
    id: 'id4',
    name: 'Huynh Tuan',
    email: 'huynhmytuan@email.com',
    personalBio: 'personalBio',
    photoUrl: 'https://picsum.photos/id/237/536/354',
  ),
];

const currentUser = AppUser(
  id: 'id4',
  name: 'Huynh Tuan',
  email: 'huynhmytuan@email.com',
  personalBio: 'personalBio',
  photoUrl: 'https://picsum.photos/id/237/536/354',
);

final conversationsData = [
  Conversation(
    id: 'id1',
    createdAt: DateTime.now(),
    creator: 'id4',
    type: ConversationType.directMessage,
    members: const ['id4', 'id2'],
  ),
  Conversation(
    id: 'id2',
    createdAt: DateTime.now(),
    creator: 'id4',
    type: ConversationType.directMessage,
    members: const ['id4', 'id3'],
  ),
  Conversation(
    id: 'id3',
    createdAt: DateTime.now(),
    creator: 'id4',
    type: ConversationType.group,
    members: const ['id4', 'id2', 'id3'],
  ),
];

final messagesData = [
  Message(
    id: '123',
    conversationId: 'id1',
    createdAt: DateTime.now(),
    authorId: 'id4',
    content: 'Hello, Nice to meet you 5',
  ),
  Message(
    id: '124',
    conversationId: 'id1',
    createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
    authorId: 'id2',
    content:
        'Hello, Nice to meet you 4 Hello, Nice to meet you 4 Hello, Nice to meet you 4 Hello, Nice to meet you 4 Hello, Nice to meet you 4 Hello, Nice to meet you 4 Hello, Nice to meet you 4 Hello, Nice to meet you 4 Hello, Nice to meet you 4 Hello, Nice to meet you 4 Hello, Nice to meet you 4 Hello, Nice to meet you 4 Hello, Nice to meet you 4 Hello, Nice to meet you 4 Hello, Nice to meet you 4 Hello, Nice to meet you 4 Hello, Nice to meet you 4 Hello, Nice to meet you 4 Hello, Nice to meet you 4 Hello, Nice to meet you 4 ',
  ),
  Message(
    id: '125',
    conversationId: 'id1',
    createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    authorId: 'id4',
    content: 'Hello, Nice to meet you 3',
  ),
  Message(
    id: '126',
    conversationId: 'id1',
    createdAt: DateTime.now().subtract(const Duration(minutes: 6)),
    authorId: 'id1',
    content: 'Hello, Nice to meet you 2',
  ),
  Message(
    id: '127',
    conversationId: 'id1',
    createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
    authorId: 'id1',
    content: 'Hello, Nice to meet you 1',
  ),
];

final projectsData = [
  Project(
    id: 'id1',
    name: 'Playing Around',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    owner: 'id4',
    viewType: ProjectViewType.calendarView,
    categories: kDefaultTaskCategories,
    description: 'This is a project which we play together. LOL, thats nice!',
    members: const ['id1', 'id2', 'id4'],
    requests: const [],
  ),
  Project(
    id: 'id2',
    name: 'Final Project Of 2022',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    owner: 'id1',
    viewType: ProjectViewType.calendarView,
    categories: kDefaultTaskCategories,
    description: 'This is a project which we play together. LOL, thats nice!',
    members: const ['id1', 'id3', 'id4'],
    requests: const [],
  ),
  Project(
    id: 'id3',
    name: 'Custom UI',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    owner: 'id2',
    viewType: ProjectViewType.dashBoard,
    categories: kDefaultTaskCategories,
    description: 'This is a project which we play together. LOL, thats nice!',
    members: const ['id3', 'id2', 'id4'],
    requests: const [],
  )
];

// var tasksData = [
//   Task(
//     id: 'id1',
//     projectId: 'id1',
//     name: 'Doing something',
//     createdBy: 'id4',
//     description: 'description something there',
//     createdAt: DateTime.now(),
//     dueDate: DateTime.now().add(
//       const Duration(days: 1),
//     ),
//     type: TaskType.task,
//     category: 'In-process',
//     isComplete: true,
//     priority: TaskPriority.none,
//     assignee: const ['id4'],
//     subTasks: const ['id5'],
//   ),
//   Task(
//     id: 'id2',
//     projectId: 'id1',
//     name: 'Doing something 1',
//     createdBy: 'id4',
//     description: 'description something there',
//     createdAt: DateTime.now(),
//     dueDate: DateTime.now().add(
//       const Duration(days: 2),
//     ),
//     type: TaskType.task,
//     category: 'To-do',
//     isComplete: false,
//     priority: TaskPriority.none,
//     assignee: const ['id4'],
//     subTasks: const [],
//   ),
//   Task(
//     id: 'id3',
//     projectId: 'id1',
//     name: 'Doing something 2',
//     createdBy: 'id4',
//     description: 'description something there',
//     createdAt: DateTime.now(),
//     dueDate: DateTime.now().add(
//       const Duration(days: 10),
//     ),
//     type: TaskType.task,
//     category: 'In-process',
//     isComplete: true,
//     priority: TaskPriority.low,
//     assignee: const ['id4'],
//     subTasks: const [],
//   ),
//   Task(
//     id: 'id4',
//     projectId: 'id1',
//     name: 'Doing something 3',
//     createdBy: 'id4',
//     description: 'description something there',
//     createdAt: DateTime.now(),
//     dueDate: DateTime.now(),
//     type: TaskType.task,
//     category: 'Complete',
//     isComplete: true,
//     priority: TaskPriority.none,
//     assignee: const ['id4'],
//     subTasks: const [],
//   ),
//   Task(
//     id: 'id5',
//     projectId: 'id1',
//     name: 'Doing something 4',
//     createdBy: 'id4',
//     description: 'description something there',
//     createdAt: DateTime.now(),
//     dueDate: DateTime.now(),
//     type: TaskType.subTask,
//     category: 'To-do',
//     isComplete: false,
//     priority: TaskPriority.none,
//     assignee: const [],
//     subTasks: const [],
//   ),
// ];
