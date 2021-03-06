--ＥＭチアモール
function c109201.initial_effect(c)
	--pendulum summon
	aux.AddPendulumProcedure(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c109201.atkcon)
	e2:SetTarget(c109201.atktg)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	--attack up/down
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetDescription(aux.Stringid(109201,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,109201)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c109201.target)
	e3:SetOperation(c109201.operation)
	c:RegisterEffect(e3)
end
function c109201.atkcon(e)
	return e:GetHandler():GetSequence()==6 or e:GetHandler():GetSequence()==7
end
function c109201.atktg(e,c)
	return c:IsType(TYPE_PENDULUM)
end
function c109201.filter(c)
	return c:IsFaceup() and c:GetAttack()~=c:GetBaseAttack()
end
function c109201.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c109201.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c109201.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c109201.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c109201.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local atk=tc:GetAttack()
		local batk=tc:GetBaseAttack()
		if batk==atk then return end
		local val=1000
		if batk>atk then
			val=-1000
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
