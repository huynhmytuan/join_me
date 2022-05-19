// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:join_me/app/app.dart';
import 'package:join_me/bootstrap.dart';
import 'package:join_me/config/router/router.dart';
import 'package:join_me/data/repositories/repositories.dart';

void main() {
  bootstrap(
    () => App(
      appRouter: AppRouter(),
      authenticationRepository: AuthenticationRepository(),
    ),
  );
}
