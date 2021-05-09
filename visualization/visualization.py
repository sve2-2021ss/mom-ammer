import pandas as pd
import streamlit as st
from pandas import DataFrame
from pydantic import BaseSettings


class Settings(BaseSettings):
  events_file_path: str

  class Config:
    env_file = '.env'
    env_file_encoding = 'utf-8'


settings = Settings()
st.title('Brokerlytics')


@st.cache
def load_data() -> DataFrame:
  return pd.read_csv(settings.events_file_path)


data_load_state = st.text('Loading data...')
data = load_data()
data_load_state.text('Loading data...done!')

st.subheader('Raw data')
st.write(data)
