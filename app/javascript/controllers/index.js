// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"

import AnalysisController from "./analysis_controller"
import DropdownController from "./dropdown_controller"
import HelloController from "./hello_controller"
import TabsController from "./tabs_controller"
import CheckpointsController from "./checkpoints_controller"

application.register("analysis", AnalysisController)
application.register("dropdown", DropdownController)
application.register("hello", HelloController)
application.register("tabs", TabsController)
application.register("checkpoints", CheckpointsController)
