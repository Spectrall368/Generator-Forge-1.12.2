<#-- @formatter:off -->
<#include "procedures.java.ftl">
<#if field$condition?has_content>
	<#assign conditions = generator.procedureNamesToObjects(field$condition)>
<#else>
	<#assign conditions = ["", ""]>
</#if>
this.tasks.addTask(${cbi+1}, new Goal() {
	{
		this.setMutexFlags(EnumSet.of(Goal.Flag.MOVE));
	}

	public boolean shouldExecute() {
		if (${name}Entity.this.getAttackTarget() != null && !${name}Entity.this.getMoveHelper().isUpdating()) {
			<#if hasProcedure(conditions[0])>
            double x = ${name}Entity.this.posX;
			double y = ${name}Entity.this.posY;
			double z = ${name}Entity.this.posZ;
			Entity entity = ${name}Entity.this;
			World world = ${name}Entity.this.world;
			</#if>
			return <#if hasProcedure(conditions[0])><@procedureOBJToConditionCode conditions[0]/><#else>true</#if>;
		} else {
			return false;
		}
	}

	@Override public boolean shouldContinueExecuting() {
		<#if hasProcedure(conditions[1])>
		double x = ${name}Entity.this.posX;
		double y = ${name}Entity.this.posY;
		double z = ${name}Entity.this.posZ;
		Entity entity = ${name}Entity.this;
		World world = ${name}Entity.this.world;
		</#if>
		return <#if hasProcedure(conditions[1])><@procedureOBJToConditionCode conditions[1]/> &&</#if>
			${name}Entity.this.getMoveHelper().isUpdating() && ${name}Entity.this.getAttackTarget() != null && ${name}Entity.this.getAttackTarget().isAlive();
	}

	@Override public void startExecuting() {
		LivingEntity livingentity = ${name}Entity.this.getAttackTarget();
		Vec3d vec3d = livingentity.getPositionEyes(1);
		${name}Entity.this.moveController.setMoveTo(vec3d.x, vec3d.y, vec3d.z, ${field$speed});
	}

	@Override public void tick() {
		LivingEntity livingentity = ${name}Entity.this.getAttackTarget();
		if (${name}Entity.this.getBoundingBox().intersects(livingentity.getBoundingBox())) {
			${name}Entity.this.attackEntityAsMob(livingentity);
		} else {
			double d0 = ${name}Entity.this.getDistanceSq(livingentity);
			if (d0 < ${field$radius}) {
				Vec3d vec3d = livingentity.getPositionEyes(1);
				${name}Entity.this.moveController.setMoveTo(vec3d.x, vec3d.y, vec3d.z, ${field$speed});
			}
		}
	}
});
<#-- @formatter:on -->
