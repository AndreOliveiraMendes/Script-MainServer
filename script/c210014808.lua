--Melodious Concert Stage
--designed and scripted by Larry126
function c210014808.initial_effect(c)
	c:EnableCounterPermit(0x9b)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,210014808)
	e1:SetOperation(c210014808.activate)
	c:RegisterEffect(e1)
	--Add counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c210014808.acop)
	c:RegisterEffect(e2)
	--atkup
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9b))
	e3:SetValue(c210014808.atkval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTarget(c210014808.desreptg)
	e5:SetOperation(c210014808.desrepop)
	c:RegisterEffect(e5)
	--search
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(440556,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCountLimit(1,2100148080)
	e6:SetCondition(c210014808.spcon)
	e6:SetTarget(c210014808.sptg)
	e6:SetOperation(c210014808.spop)
	c:RegisterEffect(e6)
end
c210014808.listed_names={0x9b,210014808}
function c210014808.cfilter(c,tp)
	return c:IsPreviousSetCard(0x9b) and bit.band(c:GetPreviousTypeOnField(),TYPE_MONSTER)>0
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
		and c:GetSummonLocation()==LOCATION_EXTRA and c:GetPreviousControler()==tp
		and c:IsPreviousPosition(POS_FACEUP) and c:GetReasonPlayer()~=tp
end
function c210014808.spfilter2(c,tc)
	return c:GetCode()==tc:GetCode()
end
function c210014808.spfilter(c,e,tp,eg)
	return c:IsSetCard(0x9b) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,tp,0,false,false)
		and not eg:IsExists(c210014808.spfilter2,1,nil,c)
end
function c210014808.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c210014808.cfilter,1,nil,tp)
end
function c210014808.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chck:IsLocation(LOCATION_GRAVE) and c210014808.spfilter(chkc,e,tp,eg) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c210014808.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,eg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectTarget(tp,c210014808.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,eg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,1,tp,LOCATION_GRAVE)
end
function c210014808.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
------------------------------------------------------------
function c210014808.thfilter(c)
	return (c:IsCode(9113513,11493868,44256816,63804637) or aux.IsCodeListed(c,0x9b) or c:IsSetCard(0x9b)) and c:IsAbleToHand()
end
function c210014808.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c210014808.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetClassCount(Card.GetCode)>=3 and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		local sg=Group.CreateGroup()
		while sg:GetCount()<3 do
			local cg=g
			if sg:GetCount()>0 then
				for sc in aux.Next(sg) do
					cg=cg:Filter(aux.NOT(Card.IsCode),nil,sc:GetCode())
				end
			end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tc=cg:SelectUnselect(sg,tp,false,false,1,3)
			if not tc then break end
			if not sg:IsContains(tc) then
				sg:AddCard(tc)
			else
				sg:RemoveCard(tc)
			end
		end
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		local tg=sg:RandomSelect(1-tp,1)
		local tc=tg:GetFirst()
		if tc:IsAbleToHand() then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			sg:RemoveCard(tc)
		end
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c210014808.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,nil,0x207a)
	if g:GetCount()>=3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleDeck(tp)
		local tg=sg:RandomSelect(1-tp,1)
		local tc=tg:GetFirst()
		if tc:IsAbleToHand() then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			sg:RemoveCard(tc)
		end
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
-----------------------------------------------------
function c210014808.atkval(e,c)
	return e:GetHandler():GetCounter(0x9b)*100
end
function c210014808.filter(c,tp)
	return c:IsControler(tp) and c:IsSetCard(0x9b)
end
function c210014808.acop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c210014808.filter,1,nil,tp) then
		e:GetHandler():AddCounter(0x9b,1)
	end
end
function c210014808.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE+REASON_RULE)
		and e:GetHandler():GetCounter(0x9b)>=2 end
	return true
end
function c210014808.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(ep,0x9b,2,REASON_EFFECT)
end