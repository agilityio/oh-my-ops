FROM python:3.6

WORKDIR /app
ADD requirements.txt /app
RUN pip install -r requirements.txt

# Custom sphinx default values
ADD ./sphinx/config.py /usr/local/lib/python3.6/site-packages/sphinx/config.py

# Custom layout template and theme configuration
ADD ./sphinx_rtd_theme/theme.conf /usr/local/lib/python3.6/site-packages/sphinx_rtd_theme/theme.conf
ADD ./sphinx_rtd_theme/layout.html /usr/local/lib/python3.6/site-packages/sphinx_rtd_theme/layout.html

# Add theme overrides styles
ADD ./sphinx_rtd_theme/css/theme_overrides.css /usr/local/lib/python3.6/site-packages/sphinx_rtd_theme/static/css/theme_overrides.css

ADD Makefile /app
ADD bin /app/bin

VOLUME [ "/app/src" ]
ENTRYPOINT [ "/app/bin/entrypoint.sh" ]
