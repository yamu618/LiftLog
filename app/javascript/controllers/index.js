import { application } from "./application";
import HelloController from "./hello_controller";
import SetsController from "./sets_controller";
import PasswordToggleController from "./password_toggle_controller";

application.register("hello", HelloController);
application.register("sets", SetsController);
application.register("password-toggle", PasswordToggleController);
