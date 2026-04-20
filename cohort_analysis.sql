WITH cleaned_users AS (
    SELECT
       *,
        CASE
            -- Рік з 4 цифр
            WHEN t1.cleaned_date ~ '^\d{1,2}-\d{1,2}-\d{4}$'
            THEN TO_DATE(t1.cleaned_date, 'DD-MM-YYYY')
            -- Рік з 2 цифр
            WHEN t1.cleaned_date ~ '^\d{1,2}-\d{1,2}-\d{2}$'
            THEN TO_DATE(t1.cleaned_date, 'DD-MM-YY')
            ELSE NULL
        END AS signup_date
    FROM (
        SELECT
            *,
            REPLACE(
                REPLACE(
                    REGEXP_REPLACE(TRIM(signup_datetime), ' .*$', ''), -- прибираємо час
                    '.', '-'
                ),
                '/', '-'
            ) AS cleaned_date
        FROM cohort_users_raw
    ) t1
),cleaned_events AS (
    SELECT
        *,
        CASE
            -- Рік з 4 цифр
            WHEN t2.cleaned_date ~ '^\d{1,2}-\d{1,2}-\d{4}$'
            THEN TO_DATE(t2.cleaned_date, 'DD-MM-YYYY')
            -- Рік з 2 цифр
            WHEN t2.cleaned_date ~ '^\d{1,2}-\d{1,2}-\d{2}$'
            THEN TO_DATE(t2.cleaned_date, 'DD-MM-YY')
            ELSE NULL
        END AS event_date
    FROM (
        SELECT
            *,
            REPLACE(
                REPLACE(
                    REGEXP_REPLACE(TRIM(event_datetime), ' .*$', ''), -- прибираємо час
                    '.', '-'
                ),
                '/', '-'
            ) AS cleaned_date
        FROM cohort_events_raw
    ) t2
),
joined_data AS (
    SELECT
        u.user_id,
        u.promo_signup_flag,
        -- місяць реєстрації (когорта)
        DATE_TRUNC('month', u.signup_date)::date AS cohort_month,
        -- місяць події
        DATE_TRUNC('month', e.event_date)::date AS activity_month,
        -- місячний зсув між подією і реєстрацією
        (
            DATE_PART('year', e.event_date) * 12 + DATE_PART('month', e.event_date)
            -
            (DATE_PART('year', u.signup_date) * 12 + DATE_PART('month', u.signup_date))
        )::int AS month_offset
    FROM cleaned_users u
    JOIN cleaned_events e
        ON u.user_id = e.user_id
    WHERE
        -- фільтрація
        u.signup_date IS NOT NULL
        AND e.event_date IS NOT NULL
        AND e.event_type IS NOT NULL
        AND e.event_type <> 'test_event'
        -- registration НЕ виключаємо
        AND DATE_TRUNC('month', e.event_date)
            BETWEEN DATE '2025-01-01' AND DATE '2025-06-01'
),
final_cohorts AS (
    SELECT
        promo_signup_flag,
        cohort_month,
        month_offset,
        COUNT(DISTINCT user_id) AS users_total
    FROM joined_data
    GROUP BY
        promo_signup_flag,
        cohort_month,
        month_offset
)
SELECT *
FROM final_cohorts
ORDER BY
    promo_signup_flag,
    cohort_month,
    month_offset;
