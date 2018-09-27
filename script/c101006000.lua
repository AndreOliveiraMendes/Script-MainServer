--Alviss of the Nordic Alfar
--Scripted by ahtelel and Eerie Code
function c101006000.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101006000,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetRange(LOCATION_REMOVED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c101006000.spcon)
	e1:SetTarget(c101006000.sptg)
	e1:SetOperation(c101006000.spop)
	c:RegisterEffect(e1)	
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101006000,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,101006000+EFFECT_COUNT_CODE_DUEL)
	e2:SetCondition(c101006000.spcon2)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101006000.sptg2)
	e2:SetOperation(c101006000.spop2)
	c:RegisterEffect(e2)
end
function c101006000.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return #eg==1 and eg:IsContains(e:GetHandler()) and re:IsActiveType(TYPE_LINK) and re:GetHandler():IsSetCard(0x42)
end
function c101006000.matfilter(c)
	return c:IsSetCard(0x42) and c:IsType(TYPE_MONSTER) and (c:IsFaceup() or c:IsLocation(LOCATION_DECK)) and c:IsLevelAbove(1)
end
function c101006000.spcheck(sg,e,tp,mg)
	return #sg==3 and sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)==2 and sg:GetSum(Card.GetLevel)==10 
		and Duel.IsExistingMatchingCard(c101006000.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,sg)
end
function c101006000.spfilter(c,e,tp,mg)
	return c:IsSetCard(0x4b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (not mg or Duel.GetLocationCountFromEx(tp,tp,mg,c)>0)
end
function c101006000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c101006000.matfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,nil)
		return aux.SelectUnselectGroup(g,e,tp,3,3,c101006000.spcheck,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,3,tp,LOCATION_DECK+LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101006000.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101006000.matfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,nil)
	local rg=aux.SelectUnselectGroup(g,e,tp,3,3,c101006000.spcheck,1,tp,HINTMSG_TOGRAVE)
	if #rg==3 and Duel.SendtoGrave(rg,REASON_EFFECT)==3 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c101006000.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101006000.cfilter(c,tp)
	return c:IsPreviousSetCard(0x4b) and c:GetPreviousControler()==tp 
end
function c101006000.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and eg:IsExists(c101006000.cfilter,1,nil,tp)
end
function c101006000.spfilter2(c,e,tp)
	return c:IsSetCard(0x4b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,c:GetCode())
end
function c101006000.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp)>0
		and Duel.IsExistingMatchingCard(c101006000.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101006000.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101006000.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end 