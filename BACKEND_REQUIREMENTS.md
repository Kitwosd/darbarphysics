# Backend Meeting Agenda & Requirements

## 1. Home Screen Carousel (Banners)
**Question:** "Should we fetch carousel data from the backend?"
**Answer:** **YES.** Hardcoding banners means you need an app update just to change a promotion.

**Requirement:**
We need an endpoint (e.g., `GET /api/banners`) that returns a list of banners. Each banner object needs:
*   `image`: URL string (Non-nullable)
*   `title`: String (Optional, for accessibility/display)
*   `action_type`: Enum/String (e.g., `'course'`, `'url'`, `'none'`)
*   `action_id`: String/Int (e.g., the `course_id` to navigate to, or the web URL to open)

**Why?** This allows you to click a banner and "go to that screen like purchase the course" dynamically.

## 2. Dynamic Categories & Filtering
**Question:** "How do we handle categories shifting the content (Courses, Videos)?"
**Answer:** The frontend shouldn't filter this manually (too much data). The Backend should filter it.

**Requirement:**
The existing endpoints for fetching data must accept a `category_id` parameter.
*   **Courses:** `GET /api/courses?category_id=101`
*   **Videos:** `GET /api/videos?category_id=101`
*   **Live Classes:** `GET /api/live-classes?category_id=101`

**Frontend Logic:**
When the user clicks a Category chip (e.g., "NEB Class 11"), we just recall these APIs with the new ID. The UI automatically updates to show only relevant items.

## 3. Course Detail Screen Data
**Question:** "What data fields are missing for the Course Detail UI?"
**Answer:** The current `CourseModel` is missing critical fields shown in the design.

**Requirement:**
Please update the `GET /api/courses/{id}` response to include:
*   `thumbnail`: String (Non-nullable image URL)
*   `duration`: String or Int (e.g., "5 hours" or `300` minutes)
*   `lesson_count`: Int (Total number of videos)
*   `student_count`: Int (Number of enrolled students)
*   `rating`: Double (e.g., 4.7)
*   `review_count`: Int (e.g., 753)
*   `lessons`: **List of Objects** (The actual curriculum)
    *   `title`: String ("Introduction to Physics")
    *   `duration`: String ("04:30")
    *   `is_locked`: Boolean (If user hasn't purchased, is this video lock/unlocked?)

## 4. Videos Section Logic
**Question:** "On what basis do we show the videos?"
**Answer:**
1.  **Default (Home):** "Recommended" or "Recent". Ask backend for `GET /api/videos/trending`.
2.  **Category Selected:** Filtered by category (as mentioned above).

## 5. Live Classes Logic
**Question:** "On categories basis or what?"
**Answer:**
*   Yes, primarily Category-based (e.g., "Physics Live Class" only relevant for Science students).
*   Also, likely need a status: `is_live_now` (Boolean) to show a "LIVE" badge.

## Summary of New/Modified Endpoints Needed

| Endpoint | Changes Needed |
| :--- | :--- |
| `GET /api/banners` | **New**. Returns dynamic ads/slides. |
| `GET /api/courses` | Add `category_id` query param support. |
| `GET /api/courses/{id}` | Add `duration`, `rating`, `lessons` list, `student_count`. |
| `GET /api/videos` | Add `category_id` support. |
