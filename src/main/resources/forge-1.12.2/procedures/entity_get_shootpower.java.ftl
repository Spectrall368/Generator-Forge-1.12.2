<@addTemplate file="utils/world/entity_vel.java.ftl"/>
(${input$projectile_entity} instanceof EntityArrow ? getMotion(${input$projectile_entity}).distanceTo(Vec3d.ZERO) : 0)