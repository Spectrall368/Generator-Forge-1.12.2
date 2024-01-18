<#-- @formatter:off -->
<#include "procedures.java.ftl">
<#if field$condition?has_content>
	<#assign conditions = generator.procedureNamesToObjects(field$condition)>
<#else>
	<#assign conditions = ["", ""]>
</#if>
this.tasks.addTask(${customBlockIndex+1}, new EntityAIBase() {
	{
		this.setMutexBits(1);
	}

	public boolean shouldExecute() {
		if (EntityCustom.this.getAttackTarget() != null && !EntityCustom.this.getMoveHelper().isUpdating()) {
			<#if hasProcedure(conditions[0])>
                        double x = EntityCustom.this.posX;
			double y = EntityCustom.this.posY;
			double z = EntityCustom.this.posZ;
			Entity entity = EntityCustom.this;
			</#if>
			return <#if hasProcedure(conditions[0])><@procedureOBJToConditionCode conditions[0]/><#else>true</#if>;
		} else {
			return false;
		}
	}

	@Override public boolean shouldContinueExecuting() {
		<#if hasProcedure(conditions[1])>
		double x = EntityCustom.this.posX;
		double y = EntityCustom.this.posY;
		double z = EntityCustom.this.posZ;
		Entity entity = EntityCustom.this;
		</#if>
		return <#if hasProcedure(conditions[1])><@procedureOBJToConditionCode conditions[1]/> &&</#if>
			EntityCustom.this.getMoveHelper().isUpdating() && EntityCustom.this.getAttackTarget() != null && EntityCustom.this.getAttackTarget().isEntityAlive();
	}

	@Override public void startExecuting() {
		EntityLivingBase livingentity = EntityCustom.this.getAttackTarget();
		Vec3d vec3d = livingentity.getPositionEyes(1);
		EntityCustom.this.moveHelper.setMoveTo(vec3d.x, vec3d.y, vec3d.z, ${field$speed});
	}

	@Override public void updateTask() {
		EntityLivingBase livingentity = EntityCustom.this.getAttackTarget();
		double d0 = EntityCustom.this.getDistanceSq(livingentity);
		if (d0 <= getAttackReachSq(livingentity)) {
			EntityCustom.this.attackEntityAsMob(livingentity);
		} else if (d0 < ${field$radius}) {
			Vec3d vec3d = livingentity.getPositionEyes(1);
			EntityCustom.this.moveHelper.setMoveTo(vec3d.x, vec3d.y, vec3d.z, ${field$speed});
		}
	}

	protected double getAttackReachSq(EntityLivingBase entity) {
		return this.attacker.width * this.attacker.width + entity.width;
    }
});
<#-- @formatter:on -->
