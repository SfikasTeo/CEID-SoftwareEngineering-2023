package com.live_the_city;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Parent;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;


/**
 * JavaFX App
 */
public class App extends Application {
    public static Scene scene;

    public static DatabaseConnection currentConnection = new DatabaseConnection();
    //public static Connection connectDB = currentConnection.getConnection();
    
    @Override
    public void start(Stage stage) throws Exception {
        scene = new Scene(loadFXML("MyJobOffers"));
        stage.setScene(scene);
        stage.show();
    }

    //change scene
    static void setRoot(String fxml) throws IOException {
        scene.setRoot(loadFXML(fxml));
    }

    //return parent fxml
    static Parent loadFXML(String fxml) throws IOException {
        FXMLLoader fxmlLoader = new FXMLLoader(App.class.getResource(fxml + ".fxml"));
        return fxmlLoader.load();
    }

    public static void main(String[] args) {
        launch();
    }

}