# Python Builder - Complete Implementation Guide

## Overview

This guide documents the complete implementation of the Python Builder feature in the `d99_learn_data_enginnering` workspace. The Python Builder is a visual drag-and-drop interface for building Python code that can execute SQL queries, similar to the SQL Builder implementation in `data_app-main-2`.

## Architecture

### Core Components

#### 1. Canvas Builder (`lib/src/features/python_builder/widget/python_builder_canvas.dart`)
- **Purpose**: Interactive drag-and-drop canvas for building Python code blocks
- **Features**:
  - Drag tiles from toolbar and drop anywhere on canvas
  - Visual preview while dragging
  - Insert tiles between existing blocks
  - Drop below existing rows to create new lines
  - Inline literal editing for input values
  - Remove blocks by tapping
  - Empty canvas handling with hidden placeholder rows for accurate drop detection
  - Row-based layout with indentation support

**Key Features**:
- `_RowDropTarget`: Drop zones for each row
- `_CanvasChip`: Individual code block display with drag/remove
- `_LiteralInlineEditor`: Inline text editing for literal values
- Empty canvas shows preview on drag (no icons/text)
- Hidden placeholder rows for first-time drop accuracy

#### 2. Python Builder Page (`lib/src/features/python_builder/page/python_builder_page.dart`)
- **Purpose**: Main page that orchestrates canvas, toolbar, and execution
- **State Management**:
  - `_canvasRows`: List of rows, each containing list of `PythonCanvasToken`
  - `_executionResult`: Stores execution results from SQL database
  - `_executionStatus`: 'COMPILATION SUCCESSFUL', 'RUNNING', 'COMPILATION FAILED'
  - Undo/Redo stacks for canvas operations

**Key Methods**:
- `_onRun()`: Serializes canvas to Python, executes via `LocalPythonExecutor`
- `_executePythonCode()`: Handles execution and error/success states
- `_buildResultsContent()`: Returns `StaticTable` widget for displaying results
- `_toggleTableView()`: Switches between results table and default toolbar content

#### 3. Python Builder Toolbar (`lib/src/features/python_builder/widget/python_builder_toolbar.dart`)
- **Purpose**: Bottom toolbar with tabs for code blocks and execution controls
- **Features**:
  - 9 tabs: Math, Logic, Operators, Data, Strings, Functions, Itertools, Errors, Variables
  - Drag-and-drop tiles for all code blocks
  - SQL-related tiles: `SELECT`, `FROM`, `WHERE`, etc. in Data tab
  - Table names: `orders`, `customers` in Variables tab
  - SQL execution functions: `EXECUTE_SQL`, `QUERY` in Functions tab
  - Table icon: Toggles between results view and default tabs
  - RUN button: Executes code and shows results
  - AnimatedSwitcher: Smoothly transitions between tabs and results table

**Toolbar Tabs**:
- **Data Tab**: Contains SQL keywords (`SELECT`, `FROM`, `WHERE`, `GROUP BY`, `ORDER BY`, `LIMIT`, `JOIN`, etc.)
- **Variables Tab**: Contains table names (`orders`, `customers`) and variable types
- **Functions Tab**: Contains SQL execution functions (`EXECUTE_SQL`, `QUERY`)

#### 4. Python Builder Config (`lib/src/features/python_builder/model/python_builder_config.dart`)
- **Purpose**: Centralized configuration for all toolbar tabs and block metadata
- **Contains**:
  - `PythonToolbarTabKind`: Enum for 9 tab types
  - Item lists for each tab (math, logic, operators, data, strings, functions, itertools, errors, variables)
  - `itemKindMap`: Maps item labels to `PythonCanvasTokenKind`
  - `itemsFor()`: Returns items for a given tab
  - `kindFor()`: Returns token kind for an item

**SQL-Related Items Added**:
- `dataItems`: `SELECT`, `FROM`, `WHERE`, `GROUP BY`, `ORDER BY`, `LIMIT`, `JOIN`, `INNER JOIN`, `LEFT JOIN`, `RIGHT JOIN`
- `functionItems`: `EXECUTE_SQL`, `QUERY`
- `variableItems`: `orders`, `customers`

### Data Models

#### 1. Python Canvas Token (`lib/src/features/python_builder/model/python_canvas_token.dart`)
- **Purpose**: Represents a single code block on the canvas
- **Properties**:
  - `label`: Display text (e.g., "SELECT", "orders")
  - `kind`: Token type (keyword, operator, literal, function, variable, etc.)
  - `wrappedToken`: For function tokens that wrap other tokens
  - `literalType`: For literal tokens (STR, INT, FLOAT, BOOL)
  - `indentation`: Python indentation level (0-based)

#### 2. Python Builder Drag Data (`lib/src/features/python_builder/model/python_builder_drag_data.dart`)
- **Purpose**: Data structure for drag-and-drop operations
- **Properties**:
  - `label`: Tile label being dragged
  - `kind`: Token kind
  - `sourceRowIndex`: Original row index (if dragging from canvas)
  - `sourceBlockIndex`: Original block index (if dragging from canvas)
  - `literalType`: For literal values
  - `wrappedToken`: For nested tokens

### Services

#### 1. Local Python Executor (`lib/src/services/local_python_executor.dart`)
- **Purpose**: Executes Python code and extracts SQL queries
- **Key Methods**:
  - `execute(String pythonCode)`: Main execution method
  - `_extractSqlQuery(String pythonCode)`: Extracts SQL from Python code using regex
  - `_looksLikeSql(String code)`: Checks if code contains SQL keywords

**SQL Detection**:
- Looks for keywords: `SELECT`, `INSERT`, `UPDATE`, `DELETE`, `WITH`
- Removes Python comments (`#`) and multi-line strings
- Extracts SQL query and executes via `LocalSqlDatabase`

#### 2. Local SQL Database (`lib/src/services/local_sql_database.dart`)
- **Purpose**: Client-side SQLite database for executing queries
- **Source**: Copied from `data_app-main-2/lib/src/services/local_sql_database.dart`
- **Features**:
  - Creates `orders` table: `order_id`, `status`, `region`, `profit`
  - Creates `customers` table: `customer_id`, `first_name`, `last_name`, `country`
  - Seeds initial data (8 orders, customer records)
  - Executes SQL queries and returns results as `List<Map<String, Object?>>`

**Key Methods**:
- `ensureInitialized()`: Creates database and schema if not exists
- `execute(String sql)`: Executes SQL and returns `SqlExecutionResult`
- `describeSchema()`: Returns table schemas

#### 3. Python Canvas Service (`lib/src/features/python_builder/services/python_canvas_service.dart`)
- **Purpose**: Serializes canvas tokens to Python code string
- **Key Methods**:
  - `serialize()`: Converts `List<List<PythonCanvasToken>>` to Python code string
  - Handles indentation, spacing, and formatting

#### 4. Python Row Repositioner (`lib/src/features/python_builder/services/python_row_repositioner.dart`)
- **Purpose**: Adjusts canvas rows based on formatted Python code
- **Key Methods**:
  - `reposition()`: Updates row structure after formatting

### Visualization & UI

#### 1. Static Table (`lib/src/common/widgets/visualization/static_table.dart`)
- **Purpose**: Professional table widget for displaying SQL query results
- **Source**: Copied from `data_app-main-2/lib/src/common/widgets/visualization/static_table.dart`
- **Features**:
  - Responsive column widths
  - Scrollable if content overflows
  - Dark theme with blue accents
  - Header row with column names
  - Data rows with proper formatting
  - NULL value handling (displays as "null")
  - Numeric column centering

**Usage**:
```dart
StaticTable(
  style: TableStylePalette.output(),
  columns: headers.map((h) => TableColumnConfig(header: h)).toList(),
  rows: dataRows,
  expandToMaxWidth: true,
)
```

**Supporting Files** (all copied from SQL builder):
- `table_models.dart`: Data models (TableStyle, TableColumnConfig, etc.)
- `table_style_presets.dart`: Style presets (`TableStylePalette.output()`)
- `table_components.dart`: Table header row component
- `table_layout_utils.dart`: Column width calculation utilities
- `table_surface.dart`: Table background and borders
- `table_theme.dart`: Theme resolution and colors

#### 2. Run Result Popup (`lib/src/features/python_builder/widget/run_result_popup.dart`)
- **Purpose**: Popup overlay showing execution status
- **Features**:
  - Shows "RUNNING" status during execution
  - Shows "COMPILATION SUCCESSFUL" on success
  - Displays row count and execution message
  - Progress bar animation
  - Slide-up animation from bottom
  - Editor and playback controls

#### 3. Compiled Failed Popup (`lib/src/features/python_builder/widget/compiled_failed_popup.dart`)
- **Purpose**: Popup overlay for compilation/execution errors
- **Features**:
  - Red error icon
  - "COMPILATION FAILED" title
  - Error message display
  - Information button for details
  - Slide-up animation from bottom

#### 4. Hint Popup (`lib/src/features/python_builder/widget/hint_popup.dart`)
- **Purpose**: Shows hints/help for users
- **Features**:
  - Hint content display
  - Next/Previous hint navigation
  - Close button
  - Slide-up animation

#### 5. Information Popup (`lib/src/features/python_builder/widget/information_popup.dart`)
- **Purpose**: Shows additional information/help
- **Features**:
  - Information content
  - Close button
  - Slide-up animation

### Popups & Error Handling

#### Popup System
All popups use `SlideTransition` with animations:

1. **Run Result Popup**:
   - Appears when RUN button is clicked
   - Shows "RUNNING" → "COMPILATION SUCCESSFUL" or "COMPILATION FAILED"
   - Automatically appears on execution start

2. **Compiled Failed Popup**:
   - Appears when execution fails
   - Shows error message
   - Allows viewing detailed information

3. **Hint Popup**:
   - Accessed via three-dots menu → Hints
   - Shows contextual hints
   - Navigate between hints

4. **Information Popup**:
   - Shows detailed information
   - Accessed from error popup or three-dots menu

#### Error Flow
1. User clicks RUN
2. Canvas serialized to Python code
3. `LocalPythonExecutor.execute()` called
4. SQL extracted from Python code
5. If SQL found → `LocalSqlDatabase.execute()` called
6. If error → `CompiledFailedPopup` shown with error message
7. If success → Results displayed in toolbar table area

### Execution Flow

#### Step-by-Step Execution:

1. **Canvas Serialization**:
   - `PythonCanvasSerializer.serialize()` converts canvas tokens to Python string
   - Example: `SELECT * FROM orders` → `"SELECT * FROM orders"`

2. **SQL Extraction**:
   - `LocalPythonExecutor._extractSqlQuery()` detects SQL keywords
   - Removes Python comments and strings
   - Extracts pure SQL query

3. **Database Execution**:
   - `LocalSqlDatabase.execute()` runs query on SQLite database
   - Returns `SqlExecutionResult` with rows or error

4. **Result Display**:
   - If success → `StaticTable` widget shown in toolbar `bottomContent`
   - If error → `CompiledFailedPopup` shown
   - Table icon becomes active when results exist

### Table Display

#### Location & Behavior:
- **Default**: Toolbar shows tabs (Data, Functions, Variables, etc.)
- **After Execution**: Toolbar switches to show `StaticTable` with results
- **Toggle**: Click table icon to switch between results and tabs
- **Animation**: Smooth transition via `AnimatedSwitcher`

#### Table Features:
- Headers from query result columns
- Rows from query result data
- Scrollable if content exceeds toolbar height
- Horizontal scroll if columns exceed width
- NULL values displayed as "null" (lowercase, dimmed)

### Canvas Features

#### Drag & Drop:
- **From Toolbar**: Drag any tile to canvas
- **On Canvas**: Drop anywhere - creates new block at drop position
- **Between Blocks**: Drop between existing blocks - inserts at position
- **New Row**: Drop below existing row - creates new line
- **Empty Canvas**: Drop on empty canvas - creates first row

#### Visual Feedback:
- **Preview**: Blue indicator line shows exact drop position
- **Dragging**: Tile becomes semi-transparent in toolbar
- **Feedback**: Dragged tile follows cursor with proper styling

#### Editing:
- **Literal Values**: Tap on literal tokens to edit inline
- **Input Field**: TextField appears for editing
- **Validation**: Type checking for literals (INT, FLOAT, STR, BOOL)
- **Mobile Keyboard**: Full keyboard support for editing

### File Structure

```
d99_learn_data_enginnering/
├── lib/
│   ├── src/
│   │   ├── features/
│   │   │   └── python_builder/
│   │   │       ├── page/
│   │   │       │   └── python_builder_page.dart         # Main page
│   │   │       ├── widget/
│   │   │       │   ├── python_builder_canvas.dart        # Canvas widget
│   │   │       │   ├── python_builder_toolbar.dart       # Toolbar widget
│   │   │       │   ├── python_builder_data_panel.dart    # Data panel widget
│   │   │       │   ├── run_result_popup.dart             # Success popup
│   │   │       │   ├── compiled_failed_popup.dart        # Error popup
│   │   │       │   ├── hint_popup.dart                   # Hints popup
│   │   │       │   └── information_popup.dart            # Info popup
│   │   │       ├── model/
│   │   │       │   ├── python_canvas_token.dart          # Token model
│   │   │       │   ├── python_builder_drag_data.dart     # Drag data model
│   │   │       │   ├── python_builder_config.dart        # Config with SQL tiles
│   │   │       │   └── block_metadata.dart               # Block metadata
│   │   │       └── services/
│   │   │           ├── python_canvas_service.dart        # Serialization
│   │   │           └── python_row_repositioner.dart      # Row repositioning
│   │   ├── services/
│   │   │   ├── local_python_executor.dart                # Python execution
│   │   │   └── local_sql_database.dart                   # SQLite database
│   │   ├── common/
│   │   │   └── widgets/
│   │   │       ├── visualization/
│   │   │       │   ├── static_table.dart                 # Table widget
│   │   │       │   ├── table_models.dart                 # Table models
│   │   │       │   ├── table_style_presets.dart          # Table styles
│   │   │       │   ├── table_components.dart             # Table components
│   │   │       │   ├── table_layout_utils.dart           # Layout utils
│   │   │       │   ├── table_surface.dart                # Table surface
│   │   │       │   └── table_theme.dart                  # Table theme
│   │   │       ├── all_types_python_widgets.dart         # Toolbar chips
│   │   │       ├── glass_box.dart                        # Glass effect widget
│   │   │       └── sql_parser/
│   │   │           └── schema.dart                       # SQL schema models
│   └── pubspec.yaml                                      # Dependencies
```

### Dependencies

**Added to `pubspec.yaml`**:
```yaml
dependencies:
  sqflite: ^2.3.0          # SQLite database
  path: ^1.9.0             # Path utilities
  auto_size_text: ^3.0.0   # Auto-sizing text (for StaticTable)
```

**Functions Tab** (6th tab):
- SQL Execution: `EXECUTE_SQL`, `QUERY`

### Database Schema

#### Orders Table:
- `order_id` (INTEGER PRIMARY KEY)
- `status` (TEXT NOT NULL)
- `region` (TEXT NOT NULL)
- `profit` (REAL NOT NULL)

**Sample Data**: 8 orders with various statuses (Completed, Pending, Cancelled, etc.)

#### Customers Table:
- `customer_id` (INTEGER PRIMARY KEY)
- `first_name` (TEXT NOT NULL)
- `last_name` (TEXT NOT NULL)
- `country` (TEXT NOT NULL)

**Sample Data**: Multiple customer records

### Usage Example

#### Building a Query:

1. **Open Data Tab** → Drag `SELECT` tile to canvas
2. **Open Operators Tab** → Drag `*` to canvas (after SELECT)
3. **Open Data Tab** → Drag `FROM` to canvas
4. **Open Variables Tab** → Drag `orders` to canvas (after FROM)

**Result**: Canvas shows `SELECT * FROM orders`

5. **Click RUN button**
6. **Results**: Table appears in toolbar showing all orders

#### More Examples:

**Query with WHERE**:
- Drag: `SELECT` → `*` → `FROM` → `orders` → `WHERE` → `status` → `=` → `'Completed'`

**Query with JOIN**:
- Drag: `SELECT` → `*` → `FROM` → `orders` → `JOIN` → `customers` → `ON` → `orders.customer_id` → `=` → `customers.customer_id`

### Key Implementation Details

#### 1. Canvas Empty State:
- Hidden placeholder rows (10 rows) ensure accurate drop detection
- First-time drop works correctly with proper row height calculation
- No visual clutter - canvas appears empty until blocks are added

#### 2. Drag & Drop Accuracy:
- `_RowDropTarget` calculates precise drop position using cursor Y coordinate
- Blue indicator line shows exact insertion point
- Supports dropping between existing blocks, at row start/end, and below rows

#### 3. Table Display:
- Replaces toolbar tabs when execution succeeds
- Uses `AnimatedSwitcher` for smooth transitions
- Scrollable for large result sets
- Maintains SQL builder styling

#### 4. Error Handling:
- Compilation errors shown in `CompiledFailedPopup`
- SQL syntax errors caught and displayed
- Database errors shown with friendly messages

#### 5. Popup System:
- All popups slide up from bottom
- Stack-based (can overlay multiple popups)
- Dismiss by tapping outside or close button

### Testing

#### Test Scenarios:

1. **Empty Canvas Drop**:
   - Drag tile to empty canvas
   - Should create first row correctly

2. **Between Blocks Drop**:
   - Drag tile between existing blocks
   - Should insert at correct position

3. **New Row Drop**:
   - Drag tile below existing row
   - Should create new row (not append to existing)

4. **SQL Execution**:
   - Build `SELECT * FROM orders`
   - Click RUN
   - Should show table with 8 rows

5. **Error Handling**:
   - Build invalid SQL (e.g., `SELECT *`)
   - Click RUN
   - Should show `CompiledFailedPopup`

6. **Table Toggle**:
   - After successful execution, click table icon
   - Should switch between results and tabs

### Differences from SQL Builder

1. **Python Style**: Supports Python-style query building (executor auto-detects SQL)
2. **Canvas Empty**: Starts with empty canvas (SQL builder had default query)
3. **More Tabs**: 9 tabs vs SQL builder's 6 tabs
4. **Table Names in Variables**: Table names shown in Variables tab (lowercase)

### Future Enhancements

1. More SQL keywords (HAVING, UNION, etc.)
2. Column suggestions when dragging FROM
3. Syntax validation before execution
4. Query history
5. Save/load canvas state
6. More database tables
7. Custom SQL queries support

## Summary

The Python Builder is a complete drag-and-drop visual programming interface that:
- Allows users to build Python code using tiles
- Automatically detects and executes SQL queries
- Displays results in a professional table widget
- Handles errors gracefully with popups
- Provides hints and information to users
- Maintains consistency with SQL builder design patterns

All components are fully integrated and working, ready for production use.

