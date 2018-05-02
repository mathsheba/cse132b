<html>

<body>
    <table border="1">
        <tr>
            <td valign="top">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="menu.html" />
            </td>
            <td>

            <%-- Set the scripting language to Java and --%>
            <%-- Import the java.sql package --%>
            <%@ page language="java" import="java.sql.*" %>
            <%@ page import="java.lang.String"%>
            <%@ page import="java.util.ArrayList"%>
    
            <%-- -------- Open Connection Code -------- --%>
            <%
                try {
                    Class.forName("org.postgresql.Driver");
                    String dbURL = "jdbc:postgresql:cse132?user=postgres&password=admin";
                    Connection conn = DriverManager.getConnection(dbURL);

            %>

            <%-- -------- INSERT Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    // Check if an insertion is requested
                    if (action != null && action.equals("insert")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO Student VALUES (?, ?, ?, ?, ?, ?)");
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
                        pstmt.setString(2, request.getParameter("FIRSTNAME"));
                        pstmt.setString(3, request.getParameter("MIDDLENAME"));
                        pstmt.setString(4, request.getParameter("LASTNAME"));
                        pstmt.setInt(5, Integer.parseInt(request.getParameter("SSN")));
                        pstmt.setString(6, request.getParameter("RESIDENCY"));
                        int rowCount = pstmt.executeUpdate();
                        
                        pstmt = conn.prepareStatement(
                        "INSERT INTO undergrad VALUES (?, ?, ?, ?)");
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
                        pstmt.setString(2, request.getParameter("COLLEGE"));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("MAJOR")));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("MINOR")));
                        rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    Statement statement = conn.createStatement();
                        
                    // Get DEGREES for Major and Minor
                    ArrayList<String> deg_id = new ArrayList<String>();
                    ArrayList<String> deg_name = new ArrayList<String>();
                    ResultSet rs = statement.executeQuery("SELECT * FROM degree");
                    while(rs.next()){
                        deg_id.add(rs.getString("degree_id"));
                        deg_name.add(rs.getString("name"));
                    }
                        
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>SSN</th>
                        <th>ID</th>
                        <th>First</th>
                        <th>Middle</th>
                        <th>Last</th>
                        <th>Residency</th>                        
                        <th>College</th>
                        <th>Major</th>
                        <th>Minor</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="undergrad.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SSN" size="10"></th>
                            <th><input value="" name="ID" size="10"></th>
                            <th><input value="" name="FIRSTNAME" size="15"></th>
                            <th><input value="" name="MIDDLENAME" size="15"></th>
                            <th><input value="" name="LASTNAME" size="15"></th>
                            <th>
                                <select name="RESIDENCY" required>
                                    <option disabled selected>Residency</option>
                                    <option value="CA">California Resident</option>
                                    <option value="Non-CA">Non-California US Resident</option>
                                    <option value="Foreign">Foreign</option>
                                </select>  
                            </th>
                            <th>
                                <select name="COLLEGE">
                                    <option disabled selected>College</option>
                                    <option value="Marshall">Marshall</option>
                                    <option value="Muir">Muir</option>
                                    <option value="Revelle">Revelle</option>
                                    <option value="Roosevelt">Roosevelt</option>
                                    <option value="Sixth">Sixth</option>
                                    <option value="Warren">Warren</option>
                                </select>     
                            </th>
                            <th>
                            <select name="MAJOR">
                                <option disabled selected>Major</option>
                                <%
                                for(int i=0; i<deg_id.size(); i++){
                                    String degree_id=deg_id.get(i);
                                    String degree_name=deg_name.get(i);
                                %>
                                   
                                    <option value="<%= degree_id %>"><%= degree_name %></option>
                                <%  
                                }
                                %>
                            </select>
                            </th>
                                
                            <th>
                                <select name="MINOR">
                                <option disabled selected>Minor</option>
                                <%
                                for(int i=0; i<deg_id.size(); i++){
                                    String degree_id=deg_id.get(i);
                                    String degree_name=deg_name.get(i);
                                %>
                                   
                                    <option value="<%= degree_id %>"><%= degree_name %></option>
                                <%  
                                }
                                %>
                            </select>
                            </th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>


            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    rs.close();
    
                    // Close the Statement
                    statement.close();
    
                    // Close the Connection
                    conn.close();
                } catch (SQLException sqle) {
                    out.println(sqle.getMessage());
                } catch (Exception e) {
                    out.println(e.getMessage());
                }
            %>
                </table>
            </td>
        </tr>
    </table>
</body>

</html>
