<#include "aiconditions.java.ftl">
this.tasks.addTask(${customBlockIndex+1}, new EntityAIAttackMelee(this, ${field$speed}, ${field$longmemory?lower_case}) {

	@Override protected double getAttackReachSqr(EntityLivingBase entity) {
		return this.attacker.width * this.attacker.width + entity.width;
    }

    <@conditionCode field$condition false/>
});
