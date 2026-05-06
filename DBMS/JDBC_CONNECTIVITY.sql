package dbmsdb;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public class App {

    // ===== CONSTANTS =====
    private static final String DB_URL      = "jdbc:oracle:thin:@localhost:1521:xe";
    private static final String DB_USER     = "prasanna1";
    private static final String DB_PASSWORD = "Prasanna1";
    private static final String DB_DRIVER   = "oracle.jdbc.driver.OracleDriver";

    private static final String DATE_PATTERN  = "yyyy-MM-dd";
    private static final String PHONE_REGEX   = "\\d{10}";
    private static final String EMAIL_REGEX   = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
    private static final String DATE_REGEX    = "\\d{4}-\\d{2}-\\d{2}";

    // ===== UTILITY: DB CONNECTION =====
 
    static Connection getConnection() {
        try {
            Class.forName(DB_DRIVER);
            return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
        } catch (ClassNotFoundException e) {
            showError(null, "Oracle JDBC driver not found. Ensure ojdbc jar is on the classpath.");
        } catch (SQLException e) {
            showError(null, "Database connection failed: " + sanitizeSQLMessage(e));
        }
        return null;
    }

    static void closeConnection(Connection conn) {
        if (conn != null) {
            try { conn.close(); } catch (SQLException ignored) { /* safe to ignore */ }
        }
    }

    // ===== UTILITY: VALIDATION =====

    static boolean isEmpty(String input) {
        return input == null || input.trim().isEmpty();
    }

    static boolean isValidEmail(String email) {
        return email != null && email.matches(EMAIL_REGEX);
    }

    static boolean isValidPhone(String phone) {
        return phone != null && phone.matches(PHONE_REGEX);
    }

    /**
     * Validates YYYY-MM-DD format AND ensures it is a real calendar date.
     */
    static boolean isValidDate(String dateStr) {
        if (dateStr == null || !dateStr.matches(DATE_REGEX)) return false;
        try {
            LocalDate.parse(dateStr, DateTimeFormatter.ofPattern(DATE_PATTERN));
            return true;
        } catch (DateTimeParseException e) {
            return false;
        }
    }

    

    // ===== UTILITY: MESSAGE HELPERS =====

    static void showError(Component parent, String message) {
        JOptionPane.showMessageDialog(parent, message, "Error", JOptionPane.ERROR_MESSAGE);
    }

    static void showSuccess(Component parent, String message) {
        JOptionPane.showMessageDialog(parent, message, "Success", JOptionPane.INFORMATION_MESSAGE);
    }

    static void showWarning(Component parent, String message) {
        JOptionPane.showMessageDialog(parent, message, "Warning", JOptionPane.WARNING_MESSAGE);
    }

    /**
     * Converts raw Oracle SQL errors into readable user messages.
     */
    static String sanitizeSQLMessage(SQLException e) {
        String msg = e.getMessage();
        if (msg == null) return "Unknown database error.";
        if (msg.contains("ORA-00001") || msg.contains("unique constraint"))  return "Duplicate entry detected.";
        if (msg.contains("ORA-01843") || msg.contains("not a valid month"))  return "Invalid date value.";
        if (msg.contains("ORA-01400"))                                        return "A required field cannot be null.";
        if (msg.contains("ORA-02291"))                                        return "Foreign key constraint violation.";
        return "Database error occurred. Please try again.";
    }

    // =========================================================================
    // LOGIN FRAME
    // =========================================================================

    static class LoginFrame extends JFrame {
        private final JTextField     idField;
        private final JPasswordField passField;

        LoginFrame() {
            setTitle("Transformer Management — Login");
            setSize(360, 220);
            setLocationRelativeTo(null);
            setDefaultCloseOperation(EXIT_ON_CLOSE);
            setLayout(new GridBagLayout());

            GridBagConstraints gbc = new GridBagConstraints();
            gbc.insets  = new Insets(8, 12, 8, 12);
            gbc.fill    = GridBagConstraints.HORIZONTAL;
            gbc.weightx = 1.0;

            gbc.gridx = 0; gbc.gridy = 0;
            add(new JLabel("Technician ID:"), gbc);
            gbc.gridx = 1;
            idField = new JTextField(15);
            add(idField, gbc);

            gbc.gridx = 0; gbc.gridy = 1;
            add(new JLabel("Phone (Password):"), gbc);
            gbc.gridx = 1;
            passField = new JPasswordField(15);
            add(passField, gbc);

            JButton loginBtn    = new JButton("Login");
            JButton registerBtn = new JButton("Register");

            gbc.gridx = 0; gbc.gridy = 2;
            add(loginBtn, gbc);
            gbc.gridx = 1;
            add(registerBtn, gbc);

            loginBtn.addActionListener(e -> login());
            registerBtn.addActionListener(e -> { new RegisterFrame(); dispose(); });
            passField.addActionListener(e -> login());   // Enter key triggers login

            setVisible(true);
        }

        void login() {
            String id   = idField.getText().trim();
            String pass = new String(passField.getPassword()).trim();

            if (isEmpty(id) || isEmpty(pass)) {
                showError(this, "Technician ID and Phone cannot be empty.");
                return;
            }

            Connection conn = getConnection();
            if (conn == null) return;

            try {
                String sql = "SELECT technician_id FROM technician WHERE technician_id = ? AND phone_no = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, id);
                ps.setString(2, pass);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    showSuccess(this, "Login successful! Welcome, " + id + ".");
                    new DashboardFrame(id);
                    dispose();
                } else {
                    showError(this, "Invalid Technician ID or Phone. Please try again.");
                }
            } catch (SQLException e) {
                showError(this, "Login error: " + sanitizeSQLMessage(e));
            } finally {
                closeConnection(conn);
            }
        }
    }

    // =========================================================================
    // REGISTER FRAME
    // =========================================================================

    static class RegisterFrame extends JFrame {
        private final JTextField idField;
        private final JTextField emailField;
        private final JTextField phoneField;

        RegisterFrame() {
            setTitle("Transformer Management — Register");
            setSize(400, 260);
            setLocationRelativeTo(null);
            setDefaultCloseOperation(DISPOSE_ON_CLOSE);
            setLayout(new GridBagLayout());

            GridBagConstraints gbc = new GridBagConstraints();
            gbc.insets  = new Insets(8, 12, 8, 12);
            gbc.fill    = GridBagConstraints.HORIZONTAL;
            gbc.weightx = 1.0;

            gbc.gridx = 0; gbc.gridy = 0;
            add(new JLabel("Technician ID:"), gbc);
            gbc.gridx = 1;
            idField = new JTextField(15);
            add(idField, gbc);

            gbc.gridx = 0; gbc.gridy = 1;
            add(new JLabel("Email:"), gbc);
            gbc.gridx = 1;
            emailField = new JTextField(15);
            add(emailField, gbc);

            gbc.gridx = 0; gbc.gridy = 2;
            add(new JLabel("Phone (10 digits):"), gbc);
            gbc.gridx = 1;
            phoneField = new JTextField(15);
            add(phoneField, gbc);

            JButton registerBtn = new JButton("Register");
            JButton backBtn     = new JButton("Back to Login");

            gbc.gridx = 0; gbc.gridy = 3;
            add(registerBtn, gbc);
            gbc.gridx = 1;
            add(backBtn, gbc);

            registerBtn.addActionListener(e -> register());
            backBtn.addActionListener(e -> { new LoginFrame(); dispose(); });

            setVisible(true);
        }

        void register() {
            String idVal    = idField.getText().trim();
            String emailVal = emailField.getText().trim();
            String phoneVal = phoneField.getText().trim();

            if (isEmpty(idVal) || isEmpty(emailVal) || isEmpty(phoneVal)) {
                showError(this, "All fields are required.");
                return;
            }
            if (!isValidEmail(emailVal)) {
                showError(this, "Invalid email format. Example: user@example.com");
                return;
            }
            if (!isValidPhone(phoneVal)) {
                showError(this, "Phone must be exactly 10 digits (numbers only).");
                return;
            }

            Connection conn = getConnection();
            if (conn == null) return;

            try {
                String sql = "INSERT INTO technician (technician_id, email, phone_no) VALUES (?, ?, ?)";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, idVal);
                ps.setString(2, emailVal);
                ps.setString(3, phoneVal);

                int rows = ps.executeUpdate();

                if (rows > 0) {
                    showSuccess(this, "Registration successful! You can now log in.");
                    new LoginFrame();
                    dispose();
                } else {
                    showError(this, "Registration failed. No records were inserted.");
                }
            } catch (SQLIntegrityConstraintViolationException e) {
                showError(this, "Technician ID or Email already exists. Use different values.");
            } catch (SQLException e) {
                showError(this, "Registration error: " + sanitizeSQLMessage(e));
            } finally {
                closeConnection(conn);
            }
        }
    }

    // =========================================================================
    // DASHBOARD FRAME
    // =========================================================================

    static class DashboardFrame extends JFrame {
        private final JTable table;
        private String currentView = "TRANSFORMER";  // tracks active view

        DashboardFrame(String technicianId) {
            setTitle("Dashboard — Logged in as: " + technicianId);
            setSize(820, 520);
            setLocationRelativeTo(null);
            setDefaultCloseOperation(EXIT_ON_CLOSE);
            setLayout(new BorderLayout(5, 5));

            table = new JTable();
            table.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
            table.setAutoResizeMode(JTable.AUTO_RESIZE_ALL_COLUMNS);
            table.setFillsViewportHeight(true);
            add(new JScrollPane(table), BorderLayout.CENTER);

            // Top panel: view switcher
            JPanel topPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 6));
            JButton viewTransformerBtn = new JButton("Transformers");
            JButton viewOilBtn         = new JButton("Oil Types");
            topPanel.add(new JLabel("View:"));
            topPanel.add(viewTransformerBtn);
            topPanel.add(viewOilBtn);
            add(topPanel, BorderLayout.NORTH);

            // Bottom panel: CRUD + logout
            JPanel bottomPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 10, 8));
            JButton addBtn    = new JButton("Add Transformer");
            JButton updateBtn = new JButton("Update Transformer");
            JButton deleteBtn = new JButton("Delete Transformer");
            JButton logoutBtn = new JButton("Logout");
            bottomPanel.add(addBtn);
            bottomPanel.add(updateBtn);
            bottomPanel.add(deleteBtn);
            bottomPanel.add(logoutBtn);
            add(bottomPanel, BorderLayout.SOUTH);

            // Wire events
            viewTransformerBtn.addActionListener(e -> loadTransformers());
            viewOilBtn.addActionListener(e -> loadOilTypes());
            addBtn.addActionListener(e -> addTransformer());
            updateBtn.addActionListener(e -> updateTransformer());
            deleteBtn.addActionListener(e -> deleteTransformer());
            logoutBtn.addActionListener(e -> { new LoginFrame(); dispose(); });

            loadTransformers();   // default view on open
            setVisible(true);
        }

        // ----- LOAD TRANSFORMERS -----
 
        void loadTransformers() {
            currentView = "TRANSFORMER";
            Connection conn = getConnection();
            if (conn == null) return;

            try {
                String sql = "SELECT transformer_id, condition_status, install_date FROM transformer ORDER BY transformer_id";
                ResultSet rs = conn.createStatement().executeQuery(sql);

                DefaultTableModel model = new DefaultTableModel(
                        new String[]{"ID", "Condition Status", "Install Date"}, 0) {
                    @Override public boolean isCellEditable(int r, int c) { return false; }
                };

                int count = 0;
                while (rs.next()) {
                    model.addRow(new Object[]{
                            rs.getString("transformer_id"),
                            rs.getString("condition_status"),
                            rs.getDate("install_date")
                    });
                    count++;
                }
                table.setModel(model);
                if (count == 0) showWarning(this, "No transformer records found in the database.");

            } catch (SQLException e) {
                showError(this, "Failed to load transformers: " + sanitizeSQLMessage(e));
            } finally {
                closeConnection(conn);
            }
        }

        // ----- LOAD OIL TYPES -----

        void loadOilTypes() {
            currentView = "OIL";
            Connection conn = getConnection();
            if (conn == null) return;

            try {
                String sql = "SELECT oil_name, manufacturer, viscosity FROM oil_type ORDER BY oil_name";
                ResultSet rs = conn.createStatement().executeQuery(sql);

                DefaultTableModel model = new DefaultTableModel(
                        new String[]{"Oil Name", "Manufacturer", "Viscosity"}, 0) {
                    @Overri    de public boolean isCellEditable(int r, int c) { return false; }
                };

                int count = 0;
                while (rs.next()) {
                    model.addRow(new Object[]{
                            rs.getString("oil_name"),
                            rs.getString("manufacturer"),
                            rs.getDouble("viscosity")
                    });
                    count++;
                }
                table.setModel(model);
                if (count == 0) showWarning(this, "No oil type records found in the database.");

            } catch (SQLException e) {
                showError(this, "Failed to load oil types: " + sanitizeSQLMessage(e));
            } finally {
                closeConnection(conn);
            }
        }

        // ----- ADD TRANSFORMER -----

        void addTransformer() {
            JTextField idField        = new JTextField();
            JTextField conditionField = new JTextField();
            JTextField dateField      = new JTextField("YYYY-MM-DD");

            Object[] fields = {
                "Transformer ID:",            idField,
                "Condition Status:",          conditionField,
                "Install Date (YYYY-MM-DD):", dateField
            };

            int result = JOptionPane.showConfirmDialog(
                    this, fields, "Add Transformer", JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);

            if (result != JOptionPane.OK_OPTION) return;

            String idVal        = idField.getText().trim();
            String conditionVal = conditionField.getText().trim();
            String dateVal      = dateField.getText().trim();

            if (isEmpty(idVal) || isEmpty(conditionVal) || isEmpty(dateVal)) {
                showError(this, "All fields are required.");
                return;
            }
            if (!isValidDate(dateVal)) {
                showError(this, "Invalid date. Use YYYY-MM-DD with a real calendar date (e.g. 2024-03-15).");
                return;
            }

            Connection conn = getConnection();
            if (conn == null) return;

            try {
                String sql = "INSERT INTO transformer (transformer_id, condition_status, install_date) " +
                             "VALUES (?, ?, TO_DATE(?, 'YYYY-MM-DD'))";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, idVal);
                ps.setString(2, conditionVal);
                ps.setString(3, dateVal);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    showSuccess(this, "Transformer '" + idVal + "' added successfully.");
                    loadTransformers();
                } else {
                    showError(this, "Insert failed. No records were added.");
                }

            } catch (SQLIntegrityConstraintViolationException e) {
                showError(this, "Transformer ID '" + idVal + "' already exists. Use a unique ID.");
            } catch (SQLException e) {
                showError(this, "Insert error: " + sanitizeSQLMessage(e));
            } finally {
                closeConnection(conn);
            }
        }

        // ----- UPDATE TRANSFORMER -----

        void updateTransformer() {
            if (!"TRANSFORMER".equals(currentView)) {
                showWarning(this, "Please switch to the Transformers view before updating.");
                return;
            }

            int row = table.getSelectedRow();
            if (row == -1) {
                showWarning(this, "Please select a transformer row to update.");
                return;
            }

            Object idObj        = table.getValueAt(row, 0);
            Object conditionObj = table.getValueAt(row, 1);

            if (idObj == null) {
                showError(this, "Selected row has no Transformer ID. Cannot update.");
                return;
            }

            String id = idObj.toString().trim();
            JTextField conditionField = new JTextField(conditionObj != null ? conditionObj.toString() : "");

            int result = JOptionPane.showConfirmDialog(
                    this,
                    new Object[]{"New Condition Status:", conditionField},
                    "Update Transformer: " + id,
                    JOptionPane.OK_CANCEL_OPTION,
                    JOptionPane.PLAIN_MESSAGE);

            if (result != JOptionPane.OK_OPTION) return;

            String newCondition = conditionField.getText().trim();
            if (isEmpty(newCondition)) {
                showError(this, "Condition status cannot be empty.");
                return;
            }

            Connection conn = getConnection();
            if (conn == null) return;

            try {
                String sql = "UPDATE transformer SET condition_status = ? WHERE transformer_id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, newCondition);
                ps.setString(2, id);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    showSuccess(this, "Transformer '" + id + "' updated successfully.");
                    loadTransformers();
                } else {
                    showWarning(this, "No record found with ID '" + id + "'. Update was not applied.");
                }

            } catch (SQLException e) {
                showError(this, "Update error: " + sanitizeSQLMessage(e));
            } finally {
                closeConnection(conn);
            }
        }

        // ----- DELETE TRANSFORMER -----

        void deleteTransformer() {
            if (!"TRANSFORMER".equals(currentView)) {
                showWarning(this, "Please switch to the Transformers view before deleting.");
                return;
            }

            int row = table.getSelectedRow();
            if (row == -1) {
                showWarning(this, "Please select a transformer row to delete.");
                return;
            }

            Object idObj = table.getValueAt(row, 0);
            if (idObj == null) {
                showError(this, "Selected row has no Transformer ID. Cannot delete.");
                return;
            }

            String id = idObj.toString().trim();

            int confirm = JOptionPane.showConfirmDialog(
                    this,
                    "Permanently delete Transformer '" + id + "'?\nThis action cannot be undone.",
                    "Confirm Delete",
                    JOptionPane.YES_NO_OPTION,
                    JOptionPane.WARNING_MESSAGE);

            if (confirm != JOptionPane.YES_OPTION) return;

            Connection conn = getConnection();
            if (conn == null) return;

            try {
                String sql = "DELETE FROM transformer WHERE transformer_id = ?";
                PreparedStatement ps = conn.prepareStatement(sql);
                ps.setString(1, id);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    showSuccess(this, "Transformer '" + id + "' deleted successfully.");
                    loadTransformers();
                } else {
                    showWarning(this, "No record found with ID '" + id + "'. Nothing was deleted.");
                }

            } catch (SQLIntegrityConstraintViolationException e) {
                showError(this, "Cannot delete Transformer '" + id + "': it is referenced by other records (foreign key).");
            } catch (SQLException e) {
                showError(this, "Delete error: " + sanitizeSQLMessage(e));
            } finally {
                closeConnection(conn);
            }
        }
    }

    // =========================================================================
    // MAIN
    // =========================================================================

    public static void main(String[] args) {
        SwingUtilities.invokeLater(LoginFrame::new);
    }
}
