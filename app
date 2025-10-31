import streamlit as st
st.set_page_config(page_title="FANX Ecosystem Simulation", layout="wide")

st.title("💠 FANX Ecosystem Simulation v1.0")
st.markdown("""
**FANX**, zamanı, dikkati ve emeği ekonomik değere dönüştüren dijital bir ekosistemdir.

Bu simülasyon, kullanıcı katılımı → XP → Credit → Cashout → Burn döngüsünü modellemektedir.
""")

if st.button("Simülasyonu Başlat"):
    st.success("Simülasyon başlatıldı. FANX döngüsü aktif.")
    st.balloons()
