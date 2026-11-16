import 'package:go_router/go_router.dart';

import '../screens/home/home_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/employee/employee_dashboard.dart';
import '../screens/admin/employee_list_screen.dart';
import '../screens/admin/add_employee_screen.dart';
import '../screens/customers/customer_list_screen.dart';
import '../screens/customers/add_customer_screen.dart';

class AppRouter {

  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const admin = '/admin';
  static const employee = '/employee';
  static const employeeList = '/employees';
  static const addEmployee = '/add-employee';
  static const customers = '/customers';
  static const addCustomer = "/add-customer";
  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [

      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: home,
        builder: (context, state) => const HomeScreen(),
      ),

      GoRoute(
        path: admin,
        builder: (context, state) => const AdminDashboard(),
      ),

      GoRoute(
        path: employee,
        builder: (context, state) => const EmployeeDashboard(),
      ),
      GoRoute(
        path: employeeList,
        builder: (context, state) => const EmployeeListScreen(),
      ),

      GoRoute(
        path: addEmployee,
        builder: (context, state) => const AddEmployeeScreen(),
      ),
      GoRoute(
        path: customers,
        builder: (context, state) => const CustomerListScreen(),
      ),
      GoRoute(
        path: addCustomer,
        builder: (context, state) => const AddCustomerScreen(),
      ),

    ],
  );
}