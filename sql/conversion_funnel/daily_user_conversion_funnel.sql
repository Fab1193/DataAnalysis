BEGIN
  DECLARE start_date DATE DEFAULT @run_date - 1;
  DECLARE end_date DATE DEFAULT @run_date - 1;

  BEGIN TRANSACTION;

  DELETE `portfolio_analytics.marts.user_conversion_funnel_daily`
  WHERE date BETWEEN start_date AND end_date;

  INSERT INTO `portfolio_analytics.gold.user_conversion_funnel_daily` (
    date,
    country,
    acquisition_channel,
    user_type,
    funnel_name,
    user_id,
    user_id_converted,
    converted_flag,
    furthest_step_reached,
    drop_reason,
    funnel_start_timestamp,
    funnel_conversion_timestamp,
    session_started_timestamp,
    product_viewed_timestamp,
    checkout_started_timestamp,
    payment_submitted_timestamp,
    purchase_completed_timestamp,
    time_to_convert_min
  )

  WITH users AS (
    SELECT
      user_id,
      signup_created_at,
      country,
      acquisition_channel
    FROM `portfolio_analytics.core.users`
  ),

  product_events AS (
    SELECT
      event_timestamp,
      user_id,
      event_name
    FROM `portfolio_analytics.raw.product_events`
    WHERE DATE(event_timestamp) BETWEEN start_date AND end_date
      AND event_name IN (
        'session_started',
        'product_viewed',
        'checkout_started',
        'payment_submitted',
        'purchase_completed'
      )
  ),

  normalized_events AS (
    SELECT
      event_timestamp,
      user_id,
      CASE
        WHEN event_name = 'session_started' THEN 'session_started'
        WHEN event_name = 'product_viewed' THEN 'product_viewed'
        WHEN event_name = 'checkout_started' THEN 'checkout_started'
        WHEN event_name = 'payment_submitted' THEN 'payment_submitted'
        WHEN event_name = 'purchase_completed' THEN 'purchase_completed'
      END AS step_name
    FROM product_events
  ),

  funnel_starts AS (
    SELECT
      DATE(event_timestamp) AS date,
      user_id,
      'purchase_funnel' AS funnel_name,
      MIN(event_timestamp) AS funnel_start_timestamp
    FROM normalized_events
    WHERE step_name = 'session_started'
    GROUP BY 1, 2, 3
  ),

  step_flags AS (
    SELECT
      s.date,
      s.user_id,
      s.funnel_name,
      s.funnel_start_timestamp,

      MIN(CASE WHEN e.step_name = 'session_started' THEN e.event_timestamp END) AS session_started_timestamp,
      MIN(CASE WHEN e.step_name = 'product_viewed' THEN e.event_timestamp END) AS product_viewed_timestamp,
      MIN(CASE WHEN e.step_name = 'checkout_started' THEN e.event_timestamp END) AS checkout_started_timestamp,
      MIN(CASE WHEN e.step_name = 'payment_submitted' THEN e.event_timestamp END) AS payment_submitted_timestamp,
      MIN(CASE WHEN e.step_name = 'purchase_completed' THEN e.event_timestamp END) AS purchase_completed_timestamp

    FROM funnel_starts AS s
    LEFT JOIN normalized_events AS e
      ON s.user_id = e.user_id
      AND e.event_timestamp >= s.funnel_start_timestamp
      AND e.event_timestamp < TIMESTAMP_ADD(s.funnel_start_timestamp, INTERVAL 1 DAY)

    GROUP BY 1, 2, 3, 4
  ),

  funnel_results AS (
    SELECT
      *,
      CASE
        WHEN purchase_completed_timestamp IS NOT NULL THEN 'purchase_completed'
        WHEN payment_submitted_timestamp IS NOT NULL THEN 'payment_submitted'
        WHEN checkout_started_timestamp IS NOT NULL THEN 'checkout_started'
        WHEN product_viewed_timestamp IS NOT NULL THEN 'product_viewed'
        WHEN session_started_timestamp IS NOT NULL THEN 'session_started'
        ELSE 'unknown'
      END AS furthest_step_reached,

      purchase_completed_timestamp AS funnel_conversion_timestamp

    FROM step_flags
  ),

  final AS (
    SELECT
      r.date,
      u.country,
      u.acquisition_channel,

      CASE
        WHEN DATE(u.signup_created_at) = r.date THEN 'New User'
        ELSE 'Existing User'
      END AS user_type,

      r.funnel_name,
      r.user_id,

      CASE
        WHEN r.funnel_conversion_timestamp IS NOT NULL THEN r.user_id
      END AS user_id_converted,

      CASE
        WHEN r.funnel_conversion_timestamp IS NOT NULL THEN 1
        ELSE 0
      END AS converted_flag,

      r.furthest_step_reached,

      CASE
        WHEN r.funnel_conversion_timestamp IS NOT NULL
          THEN 'funnel_completed'
        WHEN r.furthest_step_reached = 'payment_submitted'
          THEN 'drop after payment submission'
        WHEN r.furthest_step_reached = 'checkout_started'
          THEN 'drop after checkout started'
        WHEN r.furthest_step_reached = 'product_viewed'
          THEN 'drop after product view'
        WHEN r.furthest_step_reached = 'session_started'
          THEN 'drop after session start'
        ELSE 'unknown'
      END AS drop_reason,

      r.funnel_start_timestamp,
      r.funnel_conversion_timestamp,
      r.session_started_timestamp,
      r.product_viewed_timestamp,
      r.checkout_started_timestamp,
      r.payment_submitted_timestamp,
      r.purchase_completed_timestamp,

      ROUND(
        CASE
          WHEN r.funnel_conversion_timestamp IS NOT NULL THEN
            TIMESTAMP_DIFF(
              r.funnel_conversion_timestamp,
              r.funnel_start_timestamp,
              SECOND
            ) / 60.0
        END,
        2
      ) AS time_to_convert_min

    FROM funnel_results AS r
    LEFT JOIN users AS u
      ON r.user_id = u.user_id
  )

  SELECT *
  FROM final;

  COMMIT;

END;