import streamlit as st
from core.economy import simulate_cycle, EconomicState
from core.cashout import compute_cashout_rights
from core.dao import get_vote_power
from core.legal import compliance_snapshot

st.set_page_config(
    page_title="FANX Ecosystem Simulation",
    layout="wide"
)

st.title("💠 FANX Ecosystem Simulation v1.0")
st.caption("Kapalı devre dijital ekonomi • Deflasyonist arz • DAO kontrollü denge")

st.markdown("""
Bu arayüz, FANX ekonomisinin çekirdek döngüsünü gösterir:

**User → XP → Credit → Burn → Value↑ → NEV↑ → Reward↑ → User↑**

- Kullanıcı görev yapar → XP kazanır  
- XP → Credit'e döner  
- Her işlemde yakım (burn) olur → arz düşer  
- Arz düştükçe birim değer artar  
- NEV büyüdükçe ödül havuzu güçlenir  
- Topluluk daha çok motive olur
""")

st.header("1. Kullanıcı Katılım Girdileri")

col1, col2, col3 = st.columns(3)
with col1:
    daily_tasks = st.number_input("Günlük Görev Sayısı", min_value=0, max_value=10000, value=120)
with col2:
    avg_quality = st.slider("Kalite Skoru (0–1)", 0.0, 1.0, 0.8)
with col3:
    users = st.number_input("Aktif Kullanıcı Sayısı", min_value=1, max_value=100_000_000, value=100_000)

st.header("2. Sistem Parametreleri (DAO Ayarları)")
col4, col5, col6 = st.columns(3)
with col4:
    burn_rate = st.slider("Yakım Oranı α", 0.0, 0.10, 0.025)
with col5:
    fan_pool_share = st.slider("Fan Pool Payı", 0.10, 0.60, 0.40)
with col6:
    supply_now = st.number_input("Mevcut Arz (Supply_t)", 1_000.0, 5_000_000_000.0, 1_000_000_000.0, step=1_000_000.0)

st.header("3. Simülasyonu Çalıştır")

if st.button("▶ Ekonomiyi Simüle Et"):
    state: EconomicState = simulate_cycle(
        num_users=users,
        actions_per_day=daily_tasks,
        quality_score=avg_quality,
        burn_rate=burn_rate,
        current_supply=supply_now,
        fan_pool_share=fan_pool_share
    )
    st.success("Simülasyon tamamlandı.")
    st.metric("Toplam XP", f"{state.total_xp:,.0f}")
    st.metric("Yakılan FANX", f"{state.burn_amount:,.0f}")
    st.metric("Yeni Arz", f"{state.new_supply:,.0f}")
    st.metric("NEV", f"${state.nev:,.0f}")
    st.metric("Birim Değer", f"${state.value_per_credit:,.5f}")
    st.metric("Ortalama Fan Ödülü", f"${state.reward_avg:,.4f}")
else:
    st.info("Parametreleri seçin ve 'Ekonomiyi Simüle Et' tuşuna basın.")
