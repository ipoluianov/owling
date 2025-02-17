import 'package:flutter/material.dart';
import 'package:owling/core/repository.dart';
import 'package:owling/core/workspace/workspace.dart';
import 'package:owling/forms/home/home_config.dart';
import 'package:owling/forms/mores/about_form/about_form.dart';
import 'package:owling/forms/mores/tools/tools_debug_summary/tools_debug_summary.dart';
import 'package:owling/forms/nodes/main_form/main_form.dart';
import '../../forms/home/home.dart';
import '../../forms/home/home_add_item.dart';
import '../../forms/home/home_config_form.dart';
import '../../forms/mores/appearance_form/appearance_form.dart';
import '../../forms/mores/tools/tools_form/tools_form.dart';
import '../../forms/nodes/node_edit_form/node_edit_form.dart';
import '../../forms/mores/more_form/more_form.dart';
import '../../forms/nodes/node_add_form/node_add_form.dart';
import '../../forms/units/node_form/node_form.dart';

class RouteGenerator {
  static void processRouteArguments(RouteSettings settings) {
    if (settings.name == "/" ||
        settings.name == "/home" ||
        settings.name == "/node" ||
        settings.name == "/more") {
      Repository().lastPath = settings.name!;
    }

    if (settings.arguments is HomeFormArgument) {
      Repository().lastSelectedConnection =
          (settings.arguments as HomeFormArgument).connection;
    }

    if (settings.arguments is NodeFormArgument) {
      Repository().lastSelectedConnection =
          (settings.arguments as NodeFormArgument).connection;
    }

  }

  static Widget transBuilder(context, animation, secondaryAnimation, child) {
    //return child;
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  static Duration transDuration() {
    return const Duration(milliseconds: 200);
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    processRouteArguments(settings);

    switch (settings.name) {
      case '/':
        Repository().navIndex = NavIndex.units;
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return const MainForm();
          },
          transitionsBuilder: transBuilder,
          transitionDuration: transDuration(),
          reverseTransitionDuration: transDuration(),
        );
      case '/node':
        Repository().navIndex = NavIndex.units;
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return NodeForm(
              arg: settings.arguments as NodeFormArgument,
            );
          },
          transitionsBuilder: transBuilder,
          transitionDuration: transDuration(),
          reverseTransitionDuration: transDuration(),
        );
      case '/home':
        Repository().navIndex = NavIndex.home;
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return HomeForm(
              settings.arguments as HomeFormArgument,
            );
          },
          transitionsBuilder: transBuilder,
          transitionDuration: transDuration(),
          reverseTransitionDuration: transDuration(),
        );
      case '/home_add_item':
        Repository().navIndex = NavIndex.home;
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return HomeAddItem(
              settings.arguments as HomeAddItemArgument,
            );
          },
          transitionsBuilder: transBuilder,
          transitionDuration: transDuration(),
          reverseTransitionDuration: transDuration(),
        );
      case '/home_config_form':
        Repository().navIndex = NavIndex.home;
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return HomeConfigForm(
              settings.arguments as HomeConfigFormArgument,
            );
          },
          transitionsBuilder: transBuilder,
          transitionDuration: transDuration(),
          reverseTransitionDuration: transDuration(),
        );
      case '/more':
        Repository().navIndex = NavIndex.more;
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return MoreForm(
              settings.arguments as MoreFormArgument,
            );
          },
          transitionsBuilder: transBuilder,
          transitionDuration: transDuration(),
          reverseTransitionDuration: transDuration(),
        );
      case '/about':
        Repository().navIndex = NavIndex.more;
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return AboutForm(
              settings.arguments as AboutFormArgument,
            );
          },
          transitionsBuilder: transBuilder,
          transitionDuration: transDuration(),
          reverseTransitionDuration: transDuration(),
        );
      case '/appearance':
        Repository().navIndex = NavIndex.more;
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return AppearanceForm(
              settings.arguments as AppearanceFormArgument,
            );
          },
          transitionsBuilder: transBuilder,
          transitionDuration: transDuration(),
          reverseTransitionDuration: transDuration(),
        );
      case '/node_add':
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return NodeAddForm(
              arg: settings.arguments as NodeAddFormArgument,
            );
          },
          transitionsBuilder: transBuilder,
          transitionDuration: transDuration(),
          reverseTransitionDuration: transDuration(),
        );
      case '/node_edit':
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return NodeEditForm(
              arg: settings.arguments as NodeEditFormArgument,
            );
          },
          transitionsBuilder: transBuilder,
          transitionDuration: transDuration(),
          reverseTransitionDuration: transDuration(),
        );
      case '/tools_menu':
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return ToolsForm(
              settings.arguments as ToolsFormArgument,
            );
          },
          transitionsBuilder: transBuilder,
          transitionDuration: transDuration(),
          reverseTransitionDuration: transDuration(),
        );
              case '/tools_debug_summary':
        return PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return ToolsDebugSummaryForm(
              settings.arguments as ToolsFormArgument,
            );
          },
          transitionsBuilder: transBuilder,
          transitionDuration: transDuration(),
          reverseTransitionDuration: transDuration(),
        );

    }
    return MaterialPageRoute(builder: (_) => const Text("wrong path"));
  }
}

class MainFormArgument {}

class NodeFormArgument {
  Connection connection;
  NodeFormArgument(this.connection);
}

class ChartGroupsFormArgument {
  Connection connection;
  ChartGroupsFormArgument(this.connection);
}

class MoreFormArgument {
  Connection connection;
  MoreFormArgument(this.connection);
}

class ToolsFormArgument {
  ToolsFormArgument();
}

class HomeFormArgument {
  Connection connection;
  HomeFormArgument(this.connection);
}

class HomeAddItemArgument {
  Connection connection;
  HomeAddItemArgument(this.connection);
}

class HomeConfigFormArgument {
  Connection connection;
  HomeConfigItem item;
  HomeConfigFormArgument(this.connection, this.item);
}

class AboutFormArgument {
  Connection connection;
  AboutFormArgument(this.connection);
}

class AppearanceFormArgument {
  Connection connection;
  AppearanceFormArgument(this.connection);
}

class AccessFormArgument {
  Connection connection;
  AccessFormArgument(this.connection);
}

class GuestAccessFormArgument {
  Connection connection;
  GuestAccessFormArgument(this.connection);
}

class BillingFormArgument {
  Connection connection;
  BillingFormArgument(this.connection);
}

class MapsFormArgument {
  Connection connection;
  bool filterByFolder;
  String folderId;
  String folderName;
  MapsFormArgument(
      this.connection, this.filterByFolder, this.folderId, this.folderName);
}

class MapFormArgument {
  Connection connection;
  String id;
  bool edit;
  MapFormArgument(this.connection, this.id, this.edit);
}

class ResourceItemAddFormArgument {
  Connection connection;
  String type;
  String folder;
  String typeName;
  String typeNamePlural;
  ResourceItemAddFormArgument(this.connection, this.type, this.folder,
      this.typeName, this.typeNamePlural);
}


class MapItemDecorationAddFormArgument {
  Connection connection;
  MapItemDecorationAddFormArgument(this.connection);
}

class UsersFormArgument {
  Connection connection;
  UsersFormArgument(this.connection);
}

class UserAddFormArgument {
  Connection connection;
  UserAddFormArgument(this.connection);
}

class UserSetPasswordFormArgument {
  Connection connection;
  String userName;
  UserSetPasswordFormArgument(this.connection, this.userName);
}

class UserEditFormArgument {
  Connection connection;
  String userName;
  UserEditFormArgument(this.connection, this.userName);
}

class UserFormArgument {
  Connection connection;
  String userName;
  UserFormArgument(this.connection, this.userName);
}

class LookupFormArgument {
  Connection connection;
  String header;
  String lookupParameter;
  LookupFormArgument(this.connection, this.header, this.lookupParameter);
}

class RemoteAccessFormArgument {
  Connection connection;
  RemoteAccessFormArgument(this.connection);
}

class NodeAddFormArgument {
  bool toCloud;
  NodeAddFormArgument(this.toCloud);
}

class NodeEditFormArgument {
  Connection connection;
  NodeEditFormArgument(this.connection);
}
