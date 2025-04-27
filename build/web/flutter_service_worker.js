'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "827856a0d28c43f3db9e54f464aeed71",
"version.json": "3754e4b127dbacbae31bddd84c08a59f",
"index.html": "98ea04f751178d6b7ec33dacd622b46e",
"/": "98ea04f751178d6b7ec33dacd622b46e",
"main.dart.js": "a8b4c271c5f3ac967ada8dbee47c40bd",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"manifest.json": "5122fa614355cf3f0528b9934be3ff68",
"assets/AssetManifest.bin.json": "3ebcb49ccad76a80991103358279c176",
"assets/AssetManifest.json": "3318c644a8a377f44da89806684c0b74",
"assets/NOTICES": "6a8ebf9abdcf59257506cdc4af6fa7d1",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/awesome_notifications/test/assets/images/test_image.png": "c27a71ab4008c83eba9b554775aa12ca",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5f72d664707e4d711a1c0c240912cd50",
"assets/packages/quickalert/assets/confirm.gif": "bdc3e511c73e97fbc5cfb0c2b5f78e00",
"assets/packages/quickalert/assets/error.gif": "c307db003cf53e131f1c704bb16fb9bf",
"assets/packages/quickalert/assets/success.gif": "dcede9f3064fe66b69f7bbe7b6e3849f",
"assets/packages/quickalert/assets/loading.gif": "ac70f280e4a1b90065fe981eafe8ae13",
"assets/packages/quickalert/assets/info.gif": "90d7fface6e2d52554f8614a1f5deb6b",
"assets/packages/quickalert/assets/warning.gif": "f45dfa3b5857b812e0c8227211635cc4",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/lib/viewModel/data/data_language/total_dictionary.json": "d8ef2fdec9b94aa24d61327b33cbef8d",
"assets/lib/viewModel/data/data_language/question_languages_one.json": "0336c8c446806852bb669b699a2d045e",
"assets/lib/viewModel/data/data_language/question_languages_two.json": "f6cbd3a5f19881913ca2ac4793f4e621",
"assets/lib/viewModel/data/data_language/word.json": "0f7afe2e55ce97ff37175c07bca2e78c",
"assets/lib/viewModel/data/data_language/question_languages_four.json": "83aae9adba9bad5147d039f54f131fab",
"assets/lib/viewModel/data/data_achievement/achievement.json": "c14e0575b9b1656acc69055a72f93098",
"assets/lib/viewModel/data/data_attention/game_one_attention.json": "f72a1c4e47c527da1e158b7d225a025c",
"assets/AssetManifest.bin": "1f55d45d8e5ca45eeb53236b2c31404b",
"assets/fonts/Nunito-Bold.ttf": "91019ffb3b1df640e444b34e5a73dfc3",
"assets/fonts/Nunito-ExtraBold.ttf": "004ce174f09a95594c74016b9a8333e8",
"assets/fonts/Nunito-Medium.ttf": "108670f0b05efd5a10ca1afce69e28a3",
"assets/fonts/Nunito-Black.ttf": "18f25c22e665649aaf09be87bc6f23bb",
"assets/fonts/Nunito-Regular.ttf": "0c890be2af0d241a2387ad2c4c16af2c",
"assets/fonts/RobotoSlab-Regular.ttf": "fbd79c0a409a925126c37459e6f26dff",
"assets/fonts/Nunito-SemiBold.ttf": "45db66b4d9dff8842f4a8e5e3deb2f94",
"assets/fonts/MaterialIcons-Regular.otf": "224de2f9dfc331b3cdefe99c363b859b",
"assets/assets/email-notification-animation.json": "726e0ace28d4601268f743c5f5614c2e",
"assets/assets/Household/63.jpg": "30214f3107085249e77d4a23fd095d66",
"assets/assets/Household/77.jpg": "e2b93613c789f695d8171d246fa1c234",
"assets/assets/Household/76.jpg": "001ba0f33db88413876d212876c1673b",
"assets/assets/Household/62.jpg": "ab63df8cddbd89b5692771053afaa422",
"assets/assets/Household/74.jpg": "c9e4989baf87ed80cb5ba7ff0d331b89",
"assets/assets/Household/60.jpg": "cf8625062296901c3f321ac999d1aae0",
"assets/assets/Household/48.jpg": "aa011b44ea2f874e6f2b57dc622ed343",
"assets/assets/Household/49.jpg": "34543990c2cc6e12230c40bdfd9e37f9",
"assets/assets/Household/61.jpg": "699a0817616a4dd0dc655805dbdcc192",
"assets/assets/Household/75.jpg": "568689bd956d64ec2d50039d990011de",
"assets/assets/Household/59.jpg": "4f68dd145e0b3736ff2b47f4cb6b84c9",
"assets/assets/Household/71.jpg": "624a2057601e26ba26045badfd03b445",
"assets/assets/Household/65.jpg": "862e5212de191e9092ad6cf2164f73c4",
"assets/assets/Household/64.jpg": "ba47c75e06651eb21ccadf51e898136a",
"assets/assets/Household/70.jpg": "c7f2920d5ef1022b5e30692888588e06",
"assets/assets/Household/58.jpg": "2e0b8dd479f490cfd6c73acc2f8e481c",
"assets/assets/Household/8.jpg": "0ef761afe90886f20feaeabb7135c890",
"assets/assets/Household/66.jpg": "41fec9300571cbaad6da9f766eb260ad",
"assets/assets/Household/72.jpg": "cd61e128fcb61fe0f0ce89604d0bb69c",
"assets/assets/Household/73.jpg": "8bb5b6706087d896ceae18c27f1c1ed8",
"assets/assets/Household/67.jpg": "8aaea008bd9078bd44e7a439eb9d12f7",
"assets/assets/Household/9.jpg": "f257fdbcba40a3d45e49840a03ae183b",
"assets/assets/Household/14.jpg": "0c8c2266720ebd972474cbad05701dfd",
"assets/assets/Household/28.jpg": "7b4224b2049f77cfa82aa1d18081c510",
"assets/assets/Household/29.jpg": "a199db011c3e4b6fc8e62c6a348f451f",
"assets/assets/Household/15.jpg": "72dbef04d021234ed4de0799b045828e",
"assets/assets/Household/17.jpg": "12a4b285d65800a8701fccfc480f2492",
"assets/assets/Household/16.jpg": "07fefd467ed1b409c6ab9034fe90c9e1",
"assets/assets/Household/12.jpg": "c3bc7865764e2b5d50cfccf6025c11bb",
"assets/assets/Household/13.jpg": "b7ff8ca0996f13301c04b5686b9e8de2",
"assets/assets/Household/39.jpg": "89185f994896b1b12a53d96364038882",
"assets/assets/Household/11.jpg": "49f4d2cc7e4daa14b30fdb437ef6f66d",
"assets/assets/Household/10.jpg": "63ef6e7968b0302b0423830ae6c965e1",
"assets/assets/Household/38.jpg": "97c559312ca9d8ca03bcdc3d08c55007",
"assets/assets/Household/21.jpg": "e7ae2fc0bced7accca1284a924a446c9",
"assets/assets/Household/35.jpg": "809d653f69c2c0f6ef2a16446dfc3e62",
"assets/assets/Household/34.jpg": "7b3ac399385d0f9ec83b97d2e42e7967",
"assets/assets/Household/20.jpg": "0ff509828f8d93f0957b07e94d3b8c5e",
"assets/assets/Household/36.jpg": "6a24116ba71ea52125855355f7ad69d9",
"assets/assets/Household/22.jpg": "e6e0c0b3269f303340331f9f7d75d3d5",
"assets/assets/Household/23.jpg": "bf62113b392c6bc902106edd143010f1",
"assets/assets/Household/37.jpg": "ceaf33719e0980b17907cadbe689b68f",
"assets/assets/Household/33.jpg": "99c6417ca039420b8b0ab5be384f6a89",
"assets/assets/Household/27.jpg": "ca023b06a0066ab250a5eb6e9b8a41fa",
"assets/assets/Household/26.jpg": "9eeb21f447a6ce559c8ec7c694f4d68d",
"assets/assets/Household/32.jpg": "a0fa4ea26f84381c5321fea2b769c4c4",
"assets/assets/Household/18.jpg": "b55303e8bdff88b158012a79392c9844",
"assets/assets/Household/24.jpg": "9088d75878ccc62424f348198e6b8cfe",
"assets/assets/Household/30.jpg": "e81e07d48f01f5364b401e22ba23e475",
"assets/assets/Household/31.jpg": "22d2088e641131bcd498908dced6e24b",
"assets/assets/Household/25.jpg": "60f797fed86a2cab7f63c364f194689a",
"assets/assets/Household/19.jpg": "e1239f9458238193815a58a8d6d3a49d",
"assets/assets/Household/42.jpg": "9e675c6b4307944032ec4bcfbdff0f13",
"assets/assets/Household/4.jpg": "d99453d55fa916073775ec9ae77998e5",
"assets/assets/Household/56.jpg": "f40ad3cb56b250a2f2f1f5c4972e97da",
"assets/assets/Household/81.jpg": "75becd852953439b045ecfc527200a8d",
"assets/assets/Household/80.jpg": "7b246d2111c75b57ab5b4c47df576ba7",
"assets/assets/Household/5.jpg": "39aca7668c1345338e624dcc9dd5186c",
"assets/assets/Household/57.jpg": "ddc14f529d6222df49e00974a40d8036",
"assets/assets/Household/43.jpg": "1856621cbc3119e15ed2660b153829e7",
"assets/assets/Household/55.jpg": "d8e4774368b9e3982023dfe22bbe2b14",
"assets/assets/Household/7.jpg": "60476b13b24a2f3d5d2a7f0ad15ede8b",
"assets/assets/Household/41.jpg": "e8e98fea24e298719ef9310694f3bf52",
"assets/assets/Household/69.jpg": "2241d5f16dd04d6fa47a1e321ff83db0",
"assets/assets/Household/82.jpg": "11bf0a83cb7f535766b1e51441662d12",
"assets/assets/Household/83.jpg": "30df1bc72cdbc50370fb54bed604e6e5",
"assets/assets/Household/68.jpg": "13a1015dfde16163d3203f5092bf14ce",
"assets/assets/Household/40.jpg": "e55c2fa01bc21376719ded87d5aaa3ae",
"assets/assets/Household/54.jpg": "56c0cd3cd00f52e24be3742a8d099379",
"assets/assets/Household/6.jpg": "4f2c74ce8d71914bbcb148b6038e9543",
"assets/assets/Household/78.jpg": "7fdf23ebb140b1430e93c73b29e3b6d9",
"assets/assets/Household/2.jpg": "f52e21f009274272371630fc6eb71e3b",
"assets/assets/Household/50.jpg": "95dd3b259dac8b3d9a5b0a4ab3c78053",
"assets/assets/Household/44.jpg": "9bb0e42d9f3c20e8b0e8db590e55f7fc",
"assets/assets/Household/45.jpg": "f1faed594aa090c1d856c305e6ad6b38",
"assets/assets/Household/3.jpg": "5a7c4b04bd8fcd032102fc0d121db9f5",
"assets/assets/Household/51.jpg": "c57637b67e9f68894829610ccb888602",
"assets/assets/Household/79.jpg": "19bf186ef3a05855ea0a0ee6841624e4",
"assets/assets/Household/47.jpg": "41a0e344abe114cb1bfa568cad732f1e",
"assets/assets/Household/53.jpg": "07a75552443908fcc2a0a6eab8072cce",
"assets/assets/Household/1.jpg": "725121a7bf169dbb4b94b0da41288b8f",
"assets/assets/Household/84.jpg": "7870142c43e5e05a2e21ed9be5956546",
"assets/assets/Household/85.jpg": "a9531f4bbd6029a14a8526cc07dd17cd",
"assets/assets/Household/52.jpg": "f65bd9a1f6eb791060ef80d748de04e8",
"assets/assets/Household/46.jpg": "8f50c458dcc929af01e3146f2c7dd49a",
"assets/assets/Shape/8.jpg": "9628fed8e3ec2d9421cd01bc0da38909",
"assets/assets/Shape/9.jpg": "d96e63b8c0cc2002016bad8a69c637e3",
"assets/assets/Shape/14.jpg": "d98bca814c6a8e15680bb1e66e5e8ec5",
"assets/assets/Shape/28.jpg": "b6a67d7f2e754158935063050cc810ef",
"assets/assets/Shape/15.jpg": "435454ea4ca6f16f8dadf82d045d7c4b",
"assets/assets/Shape/17.jpg": "6384f7585bab84996f29d4afe65f6858",
"assets/assets/Shape/16.jpg": "45bf9a7657e4436a9d076af07d5b7b65",
"assets/assets/Shape/12.jpg": "a79b916679f376e22273c0f0b19f761c",
"assets/assets/Shape/13.jpg": "8b55e37d06dab74284793eb3c4dc03c8",
"assets/assets/Shape/11.jpg": "c7875b84865ec652898aae17d4edd8e3",
"assets/assets/Shape/10.jpg": "9b9d05f80e6c72084810e198f5e76168",
"assets/assets/Shape/21.jpg": "c082e516f56f44184b5fbcfee88585f7",
"assets/assets/Shape/20.jpg": "bafca5ada3e45ad407070cfd9bec6eb9",
"assets/assets/Shape/22.jpg": "71ea0fabb62af6d5b126d84695c0db77",
"assets/assets/Shape/23.jpg": "a9925a213ef0703eb759d73df2b1d58f",
"assets/assets/Shape/27.jpg": "6574bea7ae8f93eed1feeb3a5f895d9c",
"assets/assets/Shape/26.jpg": "af6c4e12b0f87838fc8c986102d94b2e",
"assets/assets/Shape/18.jpg": "fb617f1e7d2cae4ba7a5541261edc4a5",
"assets/assets/Shape/24.jpg": "be077a0ad341e764b61c8a61622863df",
"assets/assets/Shape/25.jpg": "44f9d69a95a1d4e987db854a6cdcbe8f",
"assets/assets/Shape/19.jpg": "62ca667fc38e182a0fdfd122c8c772c3",
"assets/assets/Shape/4.jpg": "c5ac5c07f897221292efd654c272a051",
"assets/assets/Shape/5.jpg": "802ff9ba2b4472ae9de9c1be353b0576",
"assets/assets/Shape/7.jpg": "dccca3be123e2477f4e236d134370761",
"assets/assets/Shape/6.jpg": "a94670e070a0735d425f19ad17449149",
"assets/assets/Shape/2.jpg": "0d23803deb753a5fc10cfa7e950140ab",
"assets/assets/Shape/3.jpg": "59dfb7e1e28abf43c08c918d662b1860",
"assets/assets/Shape/1.jpg": "b79e7f220ce92a345b1ef30221025e9a",
"assets/assets/images/weapon/Missile_Launcher.png": "3034c404abba2529dc9ef949058f8b79",
"assets/assets/images/weapon/Tower.png": "642dc228f953e7f6f3d5b7fac3f41f9c",
"assets/assets/images/weapon/Missile_Launcher1.png": "04f662dcbb8a9a3f74ef69187faf7f5f",
"assets/assets/images/weapon/shark-island-404.json": "4fea53b0b8a194a8fed99439530014e3",
"assets/assets/images/weapon/Missile.png": "e746dfe201bfffbde33c34346dbadd14",
"assets/assets/images/daily2.png": "df1015f8c081173762acfdfc7ef9e342",
"assets/assets/images/whitehole.png": "faabde1dad760369aaed6503a04068c8",
"assets/assets/images/enemy/enemyB.png": "5185d53e1ff2a5671056ab66b9bc45a1",
"assets/assets/images/enemy/enemyA.png": "bfac50780a72f78cc792015c7e91a490",
"assets/assets/images/icon_shark.png": "2a1f6bcd903d30ac3f3f24879284ec71",
"assets/assets/weather-alert-notification.json": "6961df9671db68bc43ed85cec4d91d9b",
"assets/assets/Animal/63.jpg": "9a82a48364f4997a489c5952759aa9de",
"assets/assets/Animal/77.jpg": "ba24f94f0f731014d68bc182c2fa98c7",
"assets/assets/Animal/76.jpg": "9194a8ee2f4966b3bcb6c57a4b65e88d",
"assets/assets/Animal/62.jpg": "2c78601a491e72a7f0304644b0c55fa3",
"assets/assets/Animal/74.jpg": "85d823dd5db1259d40046d6f0873b603",
"assets/assets/Animal/60.jpg": "0fe176b1df2ee3fb15cc1e5a1e3142f1",
"assets/assets/Animal/48.jpg": "16c92f06f79e0f7ad089eed241486c65",
"assets/assets/Animal/49.jpg": "de0c5a7ba9e6c4460cfc0fd25bdc5f30",
"assets/assets/Animal/61.jpg": "ecb843f9f5dc9ed62b3aa476490fe671",
"assets/assets/Animal/75.jpg": "78a70d47538a887794fb10e7333915b8",
"assets/assets/Animal/59.jpg": "ec995dde8f0ca93b03fab85549296f0c",
"assets/assets/Animal/71.jpg": "2742a2706e42e4563ac1677fa06b1dcf",
"assets/assets/Animal/65.jpg": "07a6215370001aafc98ccaa9cda8c3df",
"assets/assets/Animal/64.jpg": "676e9441d84c3d0344cbee39875cf446",
"assets/assets/Animal/70.jpg": "cb47b6e8afaa4e6be7b9c79766c08ccb",
"assets/assets/Animal/58.jpg": "cff7449400bd6e8287ffc6e8481e6687",
"assets/assets/Animal/66.jpg": "8eb224ec97a8d5f45e0dc04a915af316",
"assets/assets/Animal/72.jpg": "465a5d88221c6517441017c7ccdf4ee8",
"assets/assets/Animal/8.png": "24f6fcfa756ee70bf52c2dada6f6b968",
"assets/assets/Animal/73.jpg": "5bedcd2ff2267e71d4121bc589a7ceae",
"assets/assets/Animal/67.jpg": "a2c9df4ac7d045ffb17f20a213b7ccf5",
"assets/assets/Animal/9.jpg": "4f4f42d0ba9e70d1336511d202e7e16c",
"assets/assets/Animal/14.jpg": "3f50ac767daf8cde542a21a1cf322fca",
"assets/assets/Animal/28.jpg": "09782877cb4f720cea2515fc552e0a5c",
"assets/assets/Animal/29.jpg": "0e89bde3196e51ee06a7f0497499b7f0",
"assets/assets/Animal/15.jpg": "1201a5441798e2970f64774fdb635844",
"assets/assets/Animal/17.jpg": "c792715d975a08b9268cb27057e34ff4",
"assets/assets/Animal/16.jpg": "ab8a4ffe8ba07907e5f737a70ee0e47d",
"assets/assets/Animal/12.png": "812f57e50479e4e92df8f5c48fc7bb24",
"assets/assets/Animal/13.png": "54e1ba18c6b0a532f507f5e407c8d371",
"assets/assets/Animal/39.jpg": "f165e479e4e4492f5a32f6250f5cb99c",
"assets/assets/Animal/11.jpg": "f21eb91295c029e5dd0a18d24d8322f3",
"assets/assets/Animal/10.png": "d224e17138477c4442533587121b6711",
"assets/assets/Animal/38.jpg": "43f6aa7304d8253ce03e744853e73b19",
"assets/assets/Animal/21.jpg": "4cbde90d839f142779cd37dab8cff961",
"assets/assets/Animal/35.jpg": "427bc1266525bf6089fd4bc2b105e32c",
"assets/assets/Animal/34.png": "a5dc62d5b526f6766fa482ee70ece73a",
"assets/assets/Animal/20.jpg": "3b3c700353edd10a08b776152c951c5a",
"assets/assets/Animal/36.jpg": "a61e221d184f6f3f61d03b0ecafda3ba",
"assets/assets/Animal/22.jpg": "189e077a81bd20107b3844be82415ebb",
"assets/assets/Animal/23.jpg": "64a0e3edb28048c768c2df04905a1358",
"assets/assets/Animal/37.jpg": "b70f7a8d7c34a1c5655e80246ae2a1fa",
"assets/assets/Animal/33.jpg": "aee1db1c23fe49c350a16a0d5d6a86ad",
"assets/assets/Animal/27.jpg": "7ece866c561adf57f5b47dcb00c9d75c",
"assets/assets/Animal/26.jpg": "8407ac53c8285a893c207404ebf41990",
"assets/assets/Animal/32.jpg": "58f812a64bd0142521533441aa9cf032",
"assets/assets/Animal/18.jpg": "36296f87cbdf2aac040247213dfedfb7",
"assets/assets/Animal/24.jpg": "d14af2534e0e736d92c23c664e8a9002",
"assets/assets/Animal/30.jpg": "020f0eaa11b6dcb62d52d2cb12358c3c",
"assets/assets/Animal/31.jpg": "2a107ae7b21a50487825a597edf4a3bb",
"assets/assets/Animal/25.jpg": "dddd0514598641b16cf8d9d18f0e4716",
"assets/assets/Animal/19.jpg": "5e574ada953a44c0707c4416fb9f881d",
"assets/assets/Animal/42.jpg": "009c7ef1ad922647f8004b0d5be20efd",
"assets/assets/Animal/56.jpg": "e8a3539d5142fca730ad3153c157eaa4",
"assets/assets/Animal/4.png": "08e20942d9949de4c5e616311d5064ea",
"assets/assets/Animal/80.jpg": "4c76fac21ce48ebbc1d444b51958bd2e",
"assets/assets/Animal/5.jpg": "714acc08c7f85c27cef57b192b8678d7",
"assets/assets/Animal/57.jpg": "01f3781a64b9de7839b0307dace62a38",
"assets/assets/Animal/43.jpg": "c89b42aeace4837276b3d0f64e7079a7",
"assets/assets/Animal/55.jpg": "da1999f0e6962428435c8661cab9a7bd",
"assets/assets/Animal/41.jpg": "b304b849f1122b479a13634317d4c5a1",
"assets/assets/Animal/69.jpg": "97fb347e76889eb496c6d4b18a8b046c",
"assets/assets/Animal/7.png": "99260e6cd5a015032f025fc7d57dd076",
"assets/assets/Animal/6.png": "dc386554ab1266a1d6202bbed84b1375",
"assets/assets/Animal/68.jpg": "6bd51926be9ce41af0a3132b29864f05",
"assets/assets/Animal/40.jpg": "493f05ed1f392279625faa4622ea438f",
"assets/assets/Animal/54.jpg": "4c77990d92962b3eb84d06545740a398",
"assets/assets/Animal/78.jpg": "8dffd0575a63cc443aa8dafd73579e88",
"assets/assets/Animal/50.jpg": "34c3731ff68e231e286a45b5f953e419",
"assets/assets/Animal/44.jpg": "7b558e8dac8bff428933f603a0621259",
"assets/assets/Animal/2.png": "8d76df23ddc5dcb6c48a31629f81310e",
"assets/assets/Animal/45.jpg": "ac9618a14a2533324aad191e1836c104",
"assets/assets/Animal/3.jpg": "88b1be8d8e15c80dfa3f4f97d33150b4",
"assets/assets/Animal/51.jpg": "8b098dc1fdebaed4966f10f66f6794c3",
"assets/assets/Animal/79.jpg": "c0447cea2156c838d5f11cc43e4c2588",
"assets/assets/Animal/47.jpg": "7a7781832c0703a3f3429a5f1660d5bc",
"assets/assets/Animal/53.jpg": "70299f7814fd1334005185aa543da7fb",
"assets/assets/Animal/1.jpg": "98c8249788a54b5181bf716112df52cf",
"assets/assets/Animal/52.jpg": "de9235fa07298de79c79c57169ba27b8",
"assets/assets/Animal/46.jpg": "f7d8c03aa1c40aaabc28ee2101700074",
"assets/assets/sailing-ship.json": "f6d447e5021c6941d464885faab6d5a0",
"assets/assets/Fruit/63.jpg": "9ccfbb6d6abd1d958beaf113982ee295",
"assets/assets/Fruit/77.jpg": "caa9f8311c4f495360d4ee915c877806",
"assets/assets/Fruit/76.jpg": "8faa8ae584f586af3d500a78de2b68bc",
"assets/assets/Fruit/62.jpg": "0eba9d1c818e7d36205cfde817cc357f",
"assets/assets/Fruit/74.jpg": "0439678bb333a48b9954c7f39b5a6f95",
"assets/assets/Fruit/60.jpg": "95d02f21d04088997d7189d847f1c00c",
"assets/assets/Fruit/48.jpg": "51875f3e6816f1f2821c1d42961f5c9f",
"assets/assets/Fruit/49.jpg": "bf975a268cc5fa6fa0caf7543fb90f72",
"assets/assets/Fruit/61.jpg": "4eb1a91cc54843be5a55700cd995daa0",
"assets/assets/Fruit/75.jpg": "2930ba972c9c91bb5acb54a55edd6823",
"assets/assets/Fruit/59.jpg": "1750e71eebf805676e86f2ab434c7bf0",
"assets/assets/Fruit/71.jpg": "77120529fc117544b54a64e82c215f22",
"assets/assets/Fruit/65.jpg": "627217712d41257f4056904d6e0ec3a1",
"assets/assets/Fruit/64.jpg": "a22b775a871672ed56b4906ac133d081",
"assets/assets/Fruit/70.jpg": "b6c1db4b501702471b2f9f659da5b400",
"assets/assets/Fruit/58.jpg": "a329f243cb055489cb935402d26dd6b7",
"assets/assets/Fruit/8.jpg": "363c80732e2efe2c0f24fe7df09f0379",
"assets/assets/Fruit/66.jpg": "6c435eb63a620fef919b41742df70530",
"assets/assets/Fruit/72.jpg": "88317f78bd0d91e50c96e1d44195f017",
"assets/assets/Fruit/73.jpg": "85a3f4f39958aa2569010ae3e8f93cb9",
"assets/assets/Fruit/67.jpg": "49393f578b4215b08de75997f375b62a",
"assets/assets/Fruit/9.jpg": "e8e970ba5acffd92bd680f807b9c1342",
"assets/assets/Fruit/14.jpg": "166b84a612e74baa0cf2be670f4bf4af",
"assets/assets/Fruit/28.jpg": "f09fbdbbd20adaa09846c2973b43aaa6",
"assets/assets/Fruit/29.jpg": "9ef28587e3e2c1a48b470c41b7ec249c",
"assets/assets/Fruit/15.jpg": "ad80dfaeda83238a6f8d1489c592b001",
"assets/assets/Fruit/17.jpg": "44f1c38bc31e9172312c6435916af378",
"assets/assets/Fruit/16.jpg": "36551da35973eee1bafcd0bf31257882",
"assets/assets/Fruit/12.jpg": "840f1841798ae72dcb9916d6ba4c4ba5",
"assets/assets/Fruit/13.jpg": "3c15fda1821fa5ccb095c5196950bb2b",
"assets/assets/Fruit/39.jpg": "3fd8aae1fbb289829dfa893712f97ee9",
"assets/assets/Fruit/11.jpg": "a9648c2ea4a168e6a3542d5c6a3022eb",
"assets/assets/Fruit/10.jpg": "f2b4fdc790031340973a35420dce2ad5",
"assets/assets/Fruit/38.jpg": "c4ce29b5cd1020e08e4ed090b3d83462",
"assets/assets/Fruit/21.jpg": "413a3f0a7b43370c3bda834e42121603",
"assets/assets/Fruit/35.jpg": "25248f5477369b65dd7399ba105282ae",
"assets/assets/Fruit/34.jpg": "0c4f2a890aeaf38dae2f9c1c148ec40b",
"assets/assets/Fruit/20.jpg": "15b3a02ddc618574b19c647b408d988b",
"assets/assets/Fruit/36.jpg": "adfe46f5a647aeed24b7bd0fca36f7d6",
"assets/assets/Fruit/22.jpg": "3edb50e65a2ed01b3e2c7f8da740571d",
"assets/assets/Fruit/23.jpg": "c15fd07f0b683700d053f14fcc626216",
"assets/assets/Fruit/37.jpg": "1406476ef55384e7a74fe135f94439f6",
"assets/assets/Fruit/33.jpg": "6dd7f1ef73f476b796d15dfea7106a7c",
"assets/assets/Fruit/27.jpg": "85318257cca672c4e6566fc979ba158a",
"assets/assets/Fruit/26.jpg": "9b3f8e3dafb565baa142a89c1d55e6cf",
"assets/assets/Fruit/32.jpg": "e63813cb7560d249b84942462958d2b7",
"assets/assets/Fruit/18.jpg": "25c5e58985771d5cc0fc9a499e8c2e83",
"assets/assets/Fruit/24.jpg": "7fbfd8662af27f6dbf9804aceee7cdc6",
"assets/assets/Fruit/30.jpg": "5e5f6d9b38dac52d41740858c170a3bb",
"assets/assets/Fruit/31.jpg": "21c33eb87532d4e9b7ecfd4c72b0a840",
"assets/assets/Fruit/25.jpg": "5e1eaf01c0a608fa8611d5afdb55793d",
"assets/assets/Fruit/19.jpg": "6c593a84e2fce25de34fe65a704b4c0f",
"assets/assets/Fruit/42.jpg": "79d5bb58996b193d364dcd96c864126b",
"assets/assets/Fruit/4.jpg": "bbe02059289c0aac9f235d16eb6f5fa9",
"assets/assets/Fruit/56.jpg": "579e83cd8b877e2af4ff970bf88245c6",
"assets/assets/Fruit/80.jpg": "e1d8feaa2e3989e94a5f94078749fb03",
"assets/assets/Fruit/5.jpg": "96178816833791624a88528f7269e87d",
"assets/assets/Fruit/57.jpg": "c607ac1e7a224104edde800608ec4cb5",
"assets/assets/Fruit/43.jpg": "824a32e35ee671ac6e0fbc45637b7f22",
"assets/assets/Fruit/55.jpg": "03da11395ed6a40a8511ed1e2dadb534",
"assets/assets/Fruit/7.jpg": "86fb6925d986f628f894a8128f7b6cc0",
"assets/assets/Fruit/41.jpg": "167087e44baa96b088d155c822b92b9e",
"assets/assets/Fruit/69.jpg": "5546fcb930f6929dbec25c38391522c0",
"assets/assets/Fruit/68.jpg": "12c5b086562df2d974e09ae56c5662d5",
"assets/assets/Fruit/40.jpg": "ecce648e422c2e374290c70fa8d083ff",
"assets/assets/Fruit/54.jpg": "ad2627d2d27f8974231b74abd523444e",
"assets/assets/Fruit/6.jpg": "675c741d6677452bf0180c1fb292087c",
"assets/assets/Fruit/78.jpg": "9deedebca8cbf61ceafdf7a1393d6bec",
"assets/assets/Fruit/2.jpg": "936f4a94538c512db167881461e0a3ff",
"assets/assets/Fruit/50.jpg": "147fc05a903f42fbce28633d8d916f03",
"assets/assets/Fruit/44.jpg": "86f860e98a70e60e4303b00b74385c7c",
"assets/assets/Fruit/45.jpg": "c70270f22078a929975b58c48b7d5ef6",
"assets/assets/Fruit/3.jpg": "52a2f71fe03295c24bb06846bd1c7a14",
"assets/assets/Fruit/51.jpg": "17fd252b813ded786ede7f92bdf91716",
"assets/assets/Fruit/79.jpg": "f5e19df9c3ef661e920e6d972d881802",
"assets/assets/Fruit/47.jpg": "613b974050f37dd1362fdc069b35e9be",
"assets/assets/Fruit/53.jpg": "01c3ecbf25877931785d3ecc4f5a3940",
"assets/assets/Fruit/1.jpg": "5f3679ef08fee98b0fae242adb41d15d",
"assets/assets/Fruit/52.jpg": "09c3cea41d6248ca86f18153112e80c2",
"assets/assets/Fruit/46.jpg": "2de67e6181621bce3def2f6364a7ed96",
"assets/assets/math/flag.png": "c3993fdb05e11248f4c4032ced43f262",
"assets/assets/math/level1.png": "4c9f5c292b82a7d3bb8eb51605511b55",
"assets/assets/math/g2_bg.png": "f31374ef203d1fa40e305756048700d4",
"assets/assets/math/universe.png": "ddb7eceed9bf1007f273817e162ccf1f",
"assets/assets/math/go-back.png": "4d29b18f7ff8f6cf9458ac21b2977357",
"assets/assets/math/medal.png": "8c62d568db0183cc9af083ff00b206f1",
"assets/assets/math/clock.png": "57fb324b64ae5bf44a6232a171600617",
"assets/assets/memory1/correct.png": "610fb9f45e11c85e2d8d716a67fd0ddc",
"assets/assets/memory1/memory_three.png": "7cf3a68551914f1c8c981516c0261dc0",
"assets/assets/memory1/question.png": "f776b9a6342a1136612c4c071c9b8416",
"assets/assets/memory1/blue.png": "2b259483c6e76f74c0ef3da0f9bf318a",
"assets/assets/memory1/history.png": "56c7f31013ef9afdec20183af4bac836",
"assets/assets/memory1/star.png": "886591603ca9b8e44f824260bf9b6622",
"assets/assets/memory1/memory_two.png": "4d80a39c2a062286adccf31df5644a57",
"assets/assets/memory1/reward.png": "422a975b60014099994be3a41c3dcd2d",
"assets/assets/memory1/white.png": "88bc87051ea535d46fbe129b65aa00be",
"assets/assets/memory1/red.png": "614a111ec63f1b6ec65bcd33c7f0efbc",
"assets/assets/enemyParams.json": "4573847b39b7205e5cf8e92fc0666e5a",
"assets/assets/avatar.png": "90fe974197c612f3929ae6c27abf7317",
"assets/assets/1.svg": "bf918d65c5747a6f251d70ce69b9a962",
"assets/assets/3.svg": "b6e8b892b1680ac5704541c7b16f5c60",
"assets/assets/weaponParams.json": "aab8f8e2abbaa61bfb89933bb345c153",
"assets/assets/2.svg": "cd867996611c503a5973a97dacfff1b0",
"assets/assets/icons/star.svg": "64ab6b273ec3ea64fa0297e11d5102a6",
"assets/assets/Logo/8.jpg": "e1d1e30cbd4b8d495755a812fae04298",
"assets/assets/Logo/9.jpg": "efbc1d986b20507a744cafe9f965fc45",
"assets/assets/Logo/14.jpg": "7023aac74245df731318ed87ed80c013",
"assets/assets/Logo/28.jpg": "11a545ce189227d549daae5ae122d0fe",
"assets/assets/Logo/15.jpg": "adefb87368a1e27a9332b70f7b06d935",
"assets/assets/Logo/17.jpg": "14d24b7aafaadce8921bd8180da5439a",
"assets/assets/Logo/16.jpg": "0010e4815ecc2b614077b8771addcc7c",
"assets/assets/Logo/12.jpg": "a8bcaeb0748c73a26985404e76fd23fa",
"assets/assets/Logo/13.jpg": "898a5973137423358ebee6d924325a9b",
"assets/assets/Logo/11.jpg": "e4fc717a9dc2c70110001448c9231925",
"assets/assets/Logo/10.jpg": "2fb60d81185c6d293ba65878c98cfb7d",
"assets/assets/Logo/21.jpg": "bf12f571e071c59cfd29ba1357466b15",
"assets/assets/Logo/20.jpg": "20c7ac8a61c9d24ed167aaa3f8245d7c",
"assets/assets/Logo/22.jpg": "f27118a2bc19921d13577d8e1637c22c",
"assets/assets/Logo/23.jpg": "9407a8a9af57ec911813b27c2062f9b7",
"assets/assets/Logo/27.jpg": "ebaac973881cf651973657044ab90f48",
"assets/assets/Logo/26.jpg": "94d38e5c235332d7cb6be2b2b90853e4",
"assets/assets/Logo/18.jpg": "60c68ef1f6d4059edac111b621639252",
"assets/assets/Logo/24.jpg": "8540eeaf73316a99e50bf55517169703",
"assets/assets/Logo/25.jpg": "8dfe80dbb7332ab65772c61de06f064c",
"assets/assets/Logo/19.jpg": "38e5d93bdf02d260c14890a047d8b325",
"assets/assets/Logo/4.jpg": "f77b506fbae5e8ebc8a62ed320938091",
"assets/assets/Logo/5.jpg": "0750df5578a5adab6f2628b548d827aa",
"assets/assets/Logo/7.jpg": "60b00fe1e766f3e872d2efcfa837b168",
"assets/assets/Logo/6.jpg": "78047ebd4f9f3b8a25c9270feaa63845",
"assets/assets/Logo/2.jpg": "1ecdc11ba1a6a82f9f329dfbcca5c21e",
"assets/assets/Logo/3.jpg": "2346d32612586f4dda3d42a7736d0a57",
"assets/assets/Logo/1.jpg": "a42e1b2f5adbc3bf47fad548785db0c0",
"assets/assets/notification.json": "8741cb971133041e6ce170b09d4034c5",
"assets/assets/Transportation/63.jpg": "9d45a88ef5bddecdd1b14f66e01c2404",
"assets/assets/Transportation/77.jpg": "1fc8505fb55e76d50922e4d735102158",
"assets/assets/Transportation/76.jpg": "b2917a760210a092002a92244791bfa7",
"assets/assets/Transportation/62.jpg": "ed8087c9fc2be3920d9b90ddd0fbe113",
"assets/assets/Transportation/74.jpg": "66d365b4470336cc9f2572e5fcaf6b5d",
"assets/assets/Transportation/60.jpg": "dd94c88612f77f9e2aaa51bd568de724",
"assets/assets/Transportation/48.jpg": "3258b718acb56fa5b4c89eeaa7f38b0d",
"assets/assets/Transportation/49.jpg": "903bbe8cafcaa71d2f9b70bdfb9db557",
"assets/assets/Transportation/61.jpg": "727b6dbed9816631930d82a3be96aa5e",
"assets/assets/Transportation/75.jpg": "2585ebb6352d611b1586c17e66098111",
"assets/assets/Transportation/59.jpg": "48e48a6c3b9ea57fbb3b13b64911531c",
"assets/assets/Transportation/71.jpg": "3ced21066b5d0b45380143676cf99dd3",
"assets/assets/Transportation/65.jpg": "e752520647a5669982c6ddb6cf451598",
"assets/assets/Transportation/64.jpg": "6c2d7ab5eb5cf8fb7fe4e7b02e04c338",
"assets/assets/Transportation/70.jpg": "decbd211e90e093492e4de910bd59c7c",
"assets/assets/Transportation/58.jpg": "a53b701fbd4314d76c97ccb3d747b993",
"assets/assets/Transportation/8.jpg": "a2b1c759d2a33fcfb87556a5d935a65b",
"assets/assets/Transportation/66.jpg": "ad6fa289d7222213fd1f912a797a5d3e",
"assets/assets/Transportation/72.jpg": "cc8872ee40933ca93c3f489ed2fc518f",
"assets/assets/Transportation/73.jpg": "59787aff0b5b075ae257477d7a546419",
"assets/assets/Transportation/67.jpg": "4d89d80a580f537397bdc25e1b051b56",
"assets/assets/Transportation/9.jpg": "8439a16d809141d566c360c51be7a0ec",
"assets/assets/Transportation/14.jpg": "ca2b8be90777b89bb6a4c5dc9516d9cd",
"assets/assets/Transportation/28.jpg": "75a80673fe47353743853f0748b74625",
"assets/assets/Transportation/29.jpg": "85291910bea8860dca964b3a33b368ef",
"assets/assets/Transportation/15.jpg": "d3335805e7bba2391991f1077a95ebc4",
"assets/assets/Transportation/17.jpg": "97e5dfac7728bf5d72450125074af6e3",
"assets/assets/Transportation/16.jpg": "4534e5c8cff600cc32d7f1a70f74e662",
"assets/assets/Transportation/12.jpg": "3837e40b504b6c16fed7167253c9ac17",
"assets/assets/Transportation/13.jpg": "884bf8671b4e729ee2c78c9c4c929f23",
"assets/assets/Transportation/39.jpg": "d167405ea56c94f544f8846aadb40fc4",
"assets/assets/Transportation/11.jpg": "6d257a9c6502ae9aa526096e494115ad",
"assets/assets/Transportation/10.jpg": "9cbbd2a81f26d80b05eaf111dd97e9aa",
"assets/assets/Transportation/38.jpg": "927ffadf5e8d5a229479ee80cfb9c7b3",
"assets/assets/Transportation/21.jpg": "828829e877af5962e7c2e30b2c35cdc9",
"assets/assets/Transportation/35.jpg": "83b6ef7aef153b0c50afc65cdf8e7894",
"assets/assets/Transportation/34.jpg": "1a036fff2be4adc1c7867f249d1f8969",
"assets/assets/Transportation/20.jpg": "7ce99b3ca4e7dcccd7989d9db92291ff",
"assets/assets/Transportation/36.jpg": "8ccc3e1df4c43e94a985d7c2a2cc255c",
"assets/assets/Transportation/22.jpg": "846e5d021193b89fc5e831467cb1abd4",
"assets/assets/Transportation/23.jpg": "dc57c5bee08593dac38dd93ebb8ea28d",
"assets/assets/Transportation/37.jpg": "ea77af25a97c2f03a38e17dafad2a809",
"assets/assets/Transportation/33.jpg": "704967ed30b89db0fbc1c542e866cb0b",
"assets/assets/Transportation/27.jpg": "cac99286b25a852af72f4621f1de6949",
"assets/assets/Transportation/26.jpg": "ce65f3f88bde9c09f1ddcda133640999",
"assets/assets/Transportation/32.jpg": "91c5b078a37e17df3b3fa59ff3a7cb0e",
"assets/assets/Transportation/18.jpg": "4aeeffe1f3f120c1b037fa5422352c5e",
"assets/assets/Transportation/24.jpg": "3199d1c12430318e5cfe581d17dfcfe6",
"assets/assets/Transportation/30.jpg": "10b82841696c00746e0a6cf2644c8750",
"assets/assets/Transportation/31.jpg": "66a20699a959efaa198028e58a5cbed3",
"assets/assets/Transportation/25.jpg": "242608b3a0d719e0bd7a0c83a1122f8f",
"assets/assets/Transportation/19.jpg": "00ff4964527d16e71ea0cb82b79fd914",
"assets/assets/Transportation/42.jpg": "b0c47fd5d09804240431b7bd84b8add6",
"assets/assets/Transportation/4.jpg": "c2686ed8ff06fe464bfa24470c87efe9",
"assets/assets/Transportation/56.jpg": "2afe96e786cadaba9f7186b7fdc99ff9",
"assets/assets/Transportation/80.jpg": "090bed5ce9d6443e513356d1789ab833",
"assets/assets/Transportation/5.jpg": "423bfec2fcfcdb96b45718096f58bb84",
"assets/assets/Transportation/57.jpg": "0a683c942229a300804207e00d10f5ca",
"assets/assets/Transportation/43.jpg": "ef652098fa249d043f9fa65ac1c74f2a",
"assets/assets/Transportation/55.jpg": "430babdaa337ad5aa7eb0b346502dfde",
"assets/assets/Transportation/7.jpg": "e88274a465f7d992e248517d9a2d54f3",
"assets/assets/Transportation/41.jpg": "9c5ab22d3ca270448956926358192579",
"assets/assets/Transportation/69.jpg": "e10ddad5957886cc8ef0f0122db3a383",
"assets/assets/Transportation/68.jpg": "5cbc2e342317960e4c0b69c0c5067de5",
"assets/assets/Transportation/40.jpg": "702c301f9f3b9ecf664f2a5faf520af8",
"assets/assets/Transportation/54.jpg": "de93522a986bfdc8ffa5c76b94652e94",
"assets/assets/Transportation/6.jpg": "40ddc13dcf818e935267aff4d01e3ac1",
"assets/assets/Transportation/78.jpg": "a83a9c29204e88c53e86586e92729602",
"assets/assets/Transportation/50.jpg": "d3badb3b0278473ccaa5d3a00fb31f0b",
"assets/assets/Transportation/44.jpg": "5aa7f97fd45c43f306d19d6aabb4254b",
"assets/assets/Transportation/2.png": "b1834f9d84a0df4087dce3742d28c1e8",
"assets/assets/Transportation/45.jpg": "76fa2248107d69cf33355050c3d61252",
"assets/assets/Transportation/3.jpg": "88a33b32b3e875386c4d078a0aa97d2a",
"assets/assets/Transportation/51.jpg": "6da7a465c2150d022947975e4d7bd00a",
"assets/assets/Transportation/79.jpg": "0a0c749c26d95d1f593bacafa82c5cfc",
"assets/assets/Transportation/47.jpg": "3a24d7a5a51ba33a669ec10c8fe632f6",
"assets/assets/Transportation/53.jpg": "f40113e8558707e4804a940e3349c2da",
"assets/assets/Transportation/1.jpg": "0c703d7f18eed3c76bb21dd80aa2dacc",
"assets/assets/Transportation/52.jpg": "3faa5ec592497bcf926f07b1ce453183",
"assets/assets/Transportation/46.jpg": "538aa744767d6d5688d621915a9e46b6",
"assets/assets/congrat.json": "5b0859ff138b07fefdb46815857a92aa",
"assets/assets/congratulation.json": "0704245c8ae47ce74e58697f6c0b8e34",
"assets/assets/shark-island-404.json": "4fea53b0b8a194a8fed99439530014e3",
"assets/assets/68436-you-lose.json": "ad2d798e6c8dc87eeb63246e9a714799",
"assets/assets/animations/congratulation.json": "0704245c8ae47ce74e58697f6c0b8e34",
"assets/assets/LogoGame/shoping-math-game.jpg": "c285d2c32c7f8de2e92f0bfa874b8891",
"assets/assets/LogoGame/math-background.png": "46479346fa1638bfae0bf89c6d54e1bf",
"assets/assets/LogoGame/language-icon.jpg": "3b5da473062ec01ca798090a3922fe9d",
"assets/assets/LogoGame/game_attention2.png": "681218a2d133afb00650f22992a3e172",
"assets/assets/LogoGame/game_memory1.png": "c1e035f4e2673eb502f905dc0316aae2",
"assets/assets/LogoGame/plus-math-game-background.png": "1423a429c744f25f2e585c302dc5591b",
"assets/assets/LogoGame/game_attention3.png": "04f662dcbb8a9a3f74ef69187faf7f5f",
"assets/assets/LogoGame/game_attention1.png": "19ca42dd83a3f5b427947774e8f457c3",
"assets/assets/LogoGame/plus-math-game-icon.png": "b20bcfd7ab1424afdf70b216a1e862c9",
"assets/assets/LogoGame/game_memory2.png": "4c7a95b4632e19260a00a6756a026951",
"assets/assets/LogoGame/math-icon.jpg": "1891d86bef3633b8827183ffc3478eab",
"assets/assets/LogoGame/game_memory3.png": "4c83e348d73ff3dde3e82e5803712744",
"assets/assets/LogoGame/score_shape.jpg": "bc3a3fadbc2aefde605846e8323858ec",
"assets/assets/LogoGame/shoping-math-game-icon.jpg": "c24ee7644acecbe295d36c9578e64b29",
"assets/assets/LogoGame/background.jpg": "503886e70fab432e3ae0237c0c325831",
"assets/assets/LogoGame/logo-transparent.png": "373a71407910f93eecf23c28c4a7eef4",
"assets/assets/LogoGame/game_languages4.png": "6b03cf9161dfc7d1f9192113664be50b",
"assets/assets/LogoGame/attention-background.png": "b75feef936c4e0224cd1dcde29b82370",
"assets/assets/LogoGame/logo.jpg": "147ce75971155bf8d44c198296185186",
"assets/assets/LogoGame/game_languages3.png": "a6bfad748ad225775591839098374ff3",
"assets/assets/LogoGame/game_languages2.png": "f221546ec773641d3e03b0509b7b4d39",
"assets/assets/LogoGame/clock.jpg": "72d656e21023f6a9e2b0b517df07e7e1",
"assets/assets/LogoGame/game_languages1.png": "fa9014168f77cc75ef4004c650e3b84a",
"assets/assets/LogoGame/memory.png": "22e6967ecb9dcef8b5c625e3a8d407f4",
"assets/assets/LogoGame/attention-icon.png": "820a45fec7389780fc018942cffc825c",
"assets/assets/LogoGame/splash-1.png": "2083128e1541da1a2387376bf3058f97",
"assets/assets/LogoGame/memory-background.png": "b17ce998fed5bb4d4a6ff6686038a6d4",
"assets/assets/LogoGame/language-background.jpg": "df070ead2b73250d56c9b88ceb4b76c8",
"assets/assets/LogoGame/1.png": "21ccc0a49308b5b36c207432fdd163e5",
"assets/assets/LogoGame/splash-2.png": "8d6b65b62e8f49466e1fe517172b8573",
"assets/assets/LogoGame/splash-3.png": "a3dc87c5a23755cf3f0b47d0c81f20b0",
"assets/assets/Achievement/4.jpg": "7fcb93b5d1833611bffc01b0d8ba7fae",
"assets/assets/Achievement/5.jpg": "ca283d04c567290d24b37273d3d6d07b",
"assets/assets/Achievement/7.jpg": "bc7f1e62c6433eb01e95712193012649",
"assets/assets/Achievement/6.jpg": "af498af112a95ce36292ef6be44ec394",
"assets/assets/Achievement/2.jpg": "aa54e4f67c874c4c1b323ff8634c753a",
"assets/assets/Achievement/3.jpg": "e3d4887aff04704aab50527fb3d573f6",
"assets/assets/Achievement/1.jpg": "11b015cd09627e361f1bd8801ccf04ef",
"assets/assets/winner.json": "64f3d0b9b40eb7fe287f08078920971e",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
