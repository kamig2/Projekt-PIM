package pl.kamilagronska.recipes_app.controller;


import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import pl.kamilagronska.recipes_app.dto.*;
import pl.kamilagronska.recipes_app.entity.SortParam;
import pl.kamilagronska.recipes_app.service.RecipeService;

import java.io.IOException;
import java.util.List;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/recipes")
public class RecipeController {

    private final RecipeService recipeService;


    @GetMapping
    public ResponseEntity<List<RecipeDto> > getAllRecipes(){
        return ResponseEntity.ok(recipeService.getAllRecipes());
    }

    @GetMapping("/{recipeId}")
    public ResponseEntity<RecipeDto> getRecipe(@PathVariable Long recipeId){
        return ResponseEntity.ok(recipeService.getRecipe(recipeId));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<RecipeResponse> getUserAllRecipes(@PathVariable Long userId,
                                                             @RequestParam(value = "pageNumber", defaultValue = "0",required = false) int pageNumber,
                                                             @RequestParam(value = "pageSize",defaultValue = "5",required = false) int pageSize){
        return ResponseEntity.ok(recipeService.getUserAllRecipe(userId,pageNumber,pageSize));
    }

    @GetMapping("/userRecipes")
    public ResponseEntity<List<RecipeDto>> getLoggedUserAllRecipes(){
        return ResponseEntity.ok(recipeService.getLoggedUserAllRecipes());
    }

    @GetMapping("/find/{phrase}")
    public ResponseEntity<RecipeResponse> getRecipiesByPhrase(@PathVariable String phrase,
                                                               @RequestParam(value = "pageNumber", defaultValue = "0",required = false) int pageNumber,
                                                               @RequestParam(value = "pageSize",defaultValue = "5",required = false) int pageSize){
        return ResponseEntity.ok(recipeService.getRecipiesByPhrase(phrase,pageNumber,pageSize));
    }

    //endpoint który wyswietla posortowane przepisy według wyboru
    @GetMapping("sortedBy/{param}")
    public ResponseEntity<RecipeResponse> getSortedRecipes(@PathVariable SortParam param,
                                                            @RequestParam(value = "pageNumber", defaultValue = "0",required = false) int pageNumber,
                                                            @RequestParam(value = "pageSize",defaultValue = "5",required = false) int pageSize){
        return ResponseEntity.ok(recipeService.getSortedRecipies(param,pageNumber,pageSize));
    }

    @PostMapping(value = "/add",
            consumes = {MediaType.MULTIPART_FORM_DATA_VALUE},
            produces = {MediaType.APPLICATION_JSON_VALUE})
    public ResponseEntity<RecipeDto> addRecipe(@RequestParam(value = "title") String title,
                                               @RequestParam(value = "ingredients") String ingredients,
                                               @RequestParam("description") String description,
                                               @RequestParam(value = "files",required = false)List<MultipartFile> files) throws IOException {
        RecipeRequest request = RecipeRequest.builder()
                .title(title)
                .ingredients(ingredients)
                .description(description)
                .files(files)
                .build();
        return new ResponseEntity<>(recipeService.addRecipe(request), HttpStatus.CREATED);
    }

    @PutMapping(value = "/{recipeId}",
            consumes = {MediaType.MULTIPART_FORM_DATA_VALUE},
            produces = {MediaType.APPLICATION_JSON_VALUE})
    public ResponseEntity<RecipeDto> updateRecipe(@PathVariable Long recipeId,
                                                  @RequestParam(value = "title",required = false) String title,
                                                  @RequestParam(value = "ingredients",required = false) String ingredients,
                                                  @RequestParam(value = "description",required = false) String description,
                                                  @RequestParam(value = "files",required = false)List<MultipartFile> files) throws IOException {
        RecipeRequest request = RecipeRequest.builder()
                .title(title)
                .ingredients(ingredients)
                .description(description)
                .files(files)
                .build();
        return ResponseEntity.ok(recipeService.updateRecipe(recipeId,request/*,files*/));

    }
    @DeleteMapping("/{recipeId}")
    public ResponseEntity<String> deleteRecipe(@PathVariable Long recipeId){
        return ResponseEntity.ok(recipeService.deleteRecipe(recipeId));
    }

    @GetMapping("/{recipeId}/rating")
    public ResponseEntity<List<RatingResponse>> getOpinions(@PathVariable Long recipeId){
        return ResponseEntity.ok(recipeService.getOpinions(recipeId));
    }

    //wszystkie opinie dodane przez wybranego usera
    @GetMapping("/user/{userId}/rating")
    public ResponseEntity<List<RatingResponse>> getUserAllRatings(@PathVariable Long userId){
        return ResponseEntity.ok(recipeService.getUserAllRatings(userId));
    }

    @GetMapping("/user/rating")
    public ResponseEntity<List<RatingResponse>> getLoggedUserAllRatings(){
        return ResponseEntity.ok(recipeService.getLoggedUserAllRatings());
    }


    @PostMapping("/{recipeId}/add/rating")
    public ResponseEntity<RatingResponse> addOpinion(@PathVariable Long recipeId, @RequestBody RatingRequest request){
        return ResponseEntity.ok(recipeService.addOpinion(recipeId,request));

    }
    @PutMapping("/{recipeId}/update/rating/{ratingId}")
    public ResponseEntity<RatingResponse> updateOpinion(@PathVariable Long recipeId,
                                                        @PathVariable Long ratingId,
                                                        @RequestBody RatingRequest request){
        return ResponseEntity.ok(recipeService.updateOpinion(recipeId,ratingId,request));

    }

    @DeleteMapping("/delete/rating/{ratingId}")
    public ResponseEntity<String> deleteOpinion(@PathVariable Long ratingId){
        return ResponseEntity.ok(recipeService.deleteOpinion(ratingId));
    }


}
