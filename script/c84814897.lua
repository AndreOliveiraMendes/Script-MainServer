--騎竜
function c84814897.initial_effect(c)
	aux.AddUnionProcedure(c,aux.FilterBoolFunction(Card.IsCode,11321183),true)
	--Atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(900)
	e1:SetCondition(aux.IsUnionState)
	c:RegisterEffect(e1)
	--Def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(900)
	e2:SetCondition(aux.IsUnionState)
	c:RegisterEffect(e2)
	--direct_attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(84814897,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(aux.IsUnionState)
	e3:SetCost(c84814897.atkcost)
	e3:SetOperation(c84814897.atkop)
	c:RegisterEffect(e3)
end
c84814897.listed_names={11321183}
function c84814897.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetTargetCard(e:GetHandler():GetEquipTarget())
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c84814897.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
