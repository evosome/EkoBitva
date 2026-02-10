class_name RoadmapGenerationScreen extends Screen


#region overrides

func on_enter(ctx: Context) -> void:
    var roadmap_generation_info = ctx.roadmap_generation_info
    if !roadmap_generation_info:
        push_error("Entered screen, but `roadmap_generation_info` was not set in context")
        return
    
    var roadmap_info = roadmap_generation_info.roadmap_info
    var roadmap = Roadmap.of(roadmap_info)

    var generator = roadmap_generation_info.roadmap_generator
    var max_depth = roadmap_generation_info.roadmap_depth
    generator.generate(max_depth, roadmap)


func on_exit() -> void:
    return

#endregion


#region inner classes

class Context:
    var roadmap_generation_info: RoadmapGenerationInfo

#endregion
