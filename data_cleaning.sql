SELECT
    regexp_replace(lower(trim(full_name)), '[^a-z0-9 ]', '', 'g') AS cleaned_name,

    CASE
        WHEN length(age::text) = 0 THEN NULL
        WHEN length(age::text) = 3 THEN substr(age::text, 1, 2)::numeric
        ELSE age
    END AS cleaned_age,

    CASE
        WHEN trim(martial_status) = '' THEN NULL
        ELSE trim(martial_status)
    END AS cleaned_marital_status,

    regexp_replace(trim(lower(email)), '[^a-z0-9@._]', '', 'g') AS cleaned_email,

    CASE
        WHEN trim(phone) = '' THEN NULL
        WHEN length(trim(phone)) < 12 THEN NULL
        ELSE trim(phone)
    END AS cleaned_phone,

    regexp_replace(split_part(full_address, ',', 1), '[^a-zA-Z0-9 ]', '', 'g') AS street_address,
    regexp_replace(split_part(full_address, ',', 2), '[^a-zA-Z0-9 ]', '', 'g') AS city,
    regexp_replace(split_part(full_address, ',', 3), '[^a-zA-Z0-9 ]', '', 'g') AS state,

    regexp_replace(trim(lower(job_title)), '[^a-z0-9 ]', '', 'g') AS cleaned_job_title,

    CASE
        WHEN EXTRACT(YEAR FROM TO_DATE(membership_date, 'MM/DD/YYYY')) < 2000
        THEN TO_DATE(
            REPLACE(EXTRACT(YEAR FROM TO_DATE(membership_date, 'MM/DD/YYYY'))::TEXT, '19', '20')
            || '-' || LPAD(EXTRACT(MONTH FROM TO_DATE(membership_date, 'MM/DD/YYYY'))::TEXT, 2, '0')
            || '-' || LPAD(EXTRACT(DAY FROM TO_DATE(membership_date, 'MM/DD/YYYY'))::TEXT, 2, '0'),
            'YYYY-MM-DD')
        ELSE TO_DATE(membership_date, 'MM/DD/YYYY')
    END AS cleaned_membership_date

FROM club_member_info;